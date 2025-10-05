//
//  WeatherManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 02/10/25.
//

import SwiftUI
import Combine
import CoreData
import CoreLocation

final class WeatherManager: ObservableObject, BaseManagerDelegate, @unchecked Sendable {
    
    typealias T = WeatherModel
    
    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    var managerPublisher: AnyPublisher<WeatherModel, Never>{
        weatherSubject.eraseToAnyPublisher()
    }
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    private let weatherSubject = CurrentValueSubject<WeatherModel, Never>(WeatherModel())
    
    init(container: NSPersistentContainer) {
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        locationManager = LocationManager()
    }
    
    func setup() async -> Bool{
        _ = await loadData()
        let currentWeather = weatherSubject.value
        self.locationManager.requestLocationAccess(oldLocation: CLLocation(latitude: currentWeather.latitude, longitude: currentWeather.longitude))
        addListnerForLocationUpdate()
        if currentWeather.latitude != 0 && currentWeather.longitude != 0 {
            checkIfWeatherDataIsStale()
        }
        return true
    }
    
    private func loadData(with date: Date) async -> WeatherModel? {
        let fetchRequest = Weather.fetchRequest()
        let start = date.getStartOfDate()
        
        fetchRequest.predicate = NSPredicate(format: "date == %@", start as NSDate)
        fetchRequest.fetchLimit = 1
        
        
        if let weather = try? viewContext.fetch(fetchRequest).first {
            return WeatherModel(with: weather)
        }
        
        return nil
        
    }
    
    func loadData() async -> Bool {
        if let weather = await loadData(with: Date()) {
            weatherSubject.send(weather)
            print("Loaded weather data for \(weather.cityName ?? ""), \(weather.country ?? "")")
            return true
        }
        return false
    }
    
    func addNewOrUpdateData(_ newData: WeatherModel) async -> Bool {
        let weather = Weather(context: self.bgContext)
        newData.fillWeather(weather: weather, context: self.bgContext)
                
        await bgContext.perform {
            
            do {
                try self.bgContext.save()
            }
            catch {
                print("Error caused during saving Weather", error.localizedDescription)
            }
        }
        
        self.weatherSubject.send(newData)
        return true
    }
    
    func deleteData(_ deleteData: WeatherModel) async -> Bool {
        return true
    }
    
    private func addListnerForLocationUpdate() {
        self.locationManager.$placeDetails
            .sink { [weak self] (placeDetails) in
                if let placeDetails = placeDetails {
                    self?.checkIfLocationUpdatedAndProceed(placeDetails: placeDetails)
                }
            }
            .store(in: &cancellables)
    }
    
    private func checkIfLocationUpdatedAndProceed(placeDetails: PlaceDetails) {
        let currentWeather = weatherSubject.value
        if currentWeather.cityName != placeDetails.name || currentWeather.country != placeDetails.country {
            fetchWeatherDetailsFromAPI(place: placeDetails)
        }
    }
    
    func checkIfWeatherDataIsStale() {
        let currentWeather = weatherSubject.value
        if let lastUpdate = currentWeather.updatedAt {
            let hoursSinceUpdate = Calendar.current.dateComponents([.hour], from: lastUpdate, to: Date()).hour ?? 0
            if hoursSinceUpdate >= AppConstants.thresholdTime {
                fetchWeatherDetailsFromAPI(place: PlaceDetails(latitude: currentWeather.latitude, longitude: currentWeather.longitude, name: currentWeather.cityName, state: currentWeather.state, country: currentWeather.country))
            }
        }
    }
    
    func manualRefreshWeatherData() async -> Bool{
        let currentWeather = weatherSubject.value
        return await withCheckedContinuation { continuation in
            fetchWeatherDetailsFromAPI(place: PlaceDetails(latitude: currentWeather.latitude, longitude: currentWeather.longitude, name: currentWeather.cityName, state: currentWeather.state, country: currentWeather.country)) { isSuccess in
                continuation.resume(returning: isSuccess)
            }
        }
    }
    
    private func fetchWeatherDetailsFromAPI(place: PlaceDetails, completionHandler: ((Bool) -> Void)? = nil) {
        print("Fetching weather details from API")
    
        URLSessionManager().request(urlString: String(format: APIName.weatherAPI.rawValue, "\(place.latitude)", "\(place.longitude)"))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                guard let _ = self else { return }
                
                switch completion {
                case .failure(let err):
                    print("GET failed:", err)
                    completionHandler?(false)
                    
                case .finished:
                    print("GET finished")
                }
            } receiveValue: {[weak self] (meteoModel: OpenMeteoModel) in
                
                guard let weakSelf = self else { return }
                
                var newMeteoModel = meteoModel
                newMeteoModel.place = place
                
                let weatherModel = WeatherModel(meteoModel: newMeteoModel)
                
                Task{
                    _ = await weakSelf.addNewOrUpdateData(weatherModel)
                    completionHandler?(true)
                }
            }
            .store(in: &cancellables)
        
    }
    
}
