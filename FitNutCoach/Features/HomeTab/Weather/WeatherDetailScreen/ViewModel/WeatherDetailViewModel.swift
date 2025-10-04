//
//  WeatherDetailViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/09/25.
//

import SwiftUI
import Combine

class WeatherDetailViewModel: ObservableObject {
    
    @Published var weatherCondition: WeatherCondition = .clear
    @Published var currentWeather: WeatherModel?

    private var weatherManager: WeatherManager?
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.removeAll()
        currentWeather = nil
    }
    
    func onAppear(weatherManager: WeatherManager) {
        self.weatherManager = weatherManager
        self.weatherManager?.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] weatherModel in
                self?.currentWeather = weatherModel
            }
            .store(in: &cancellables)
    }
    
    func getWeatherBackground() -> LinearGradient? {
        currentWeather?.weatherCondition.getTheme().getGradient()
    }
    
    func getCurrentWeather() -> String {
        if let currentWeather = self.currentWeather {
            return "\(currentWeather.weatherCondition.getIcon()) \(currentWeather.weatherCondition.getName())"
        }
        return ""
    }

    func getWeatherTemperature() -> String {
        return currentWeather?.temperature ?? ""
    }
    
    func getPlaceName() -> String {
        return "\(currentWeather?.cityName ?? ""), \(currentWeather?.state ?? "\(currentWeather?.country ?? "")")"
    }
    
    func getFeelsLike() -> String {
        return "\(AppTexts.feelsLikeText): \(currentWeather?.feelsLikeTemperature ?? "")"
    }
    
    func getHumidity() -> String {
        return "\(AppTexts.humidityText): \(currentWeather?.humidity ?? "")"
    }
    
    func getWindSpeed() -> String {
        return "\(AppTexts.windSpeedText): \(currentWeather?.windSpeed ?? "")"
    }
    
    func getPrecipitation() -> String {
        return "\(AppTexts.precipitationText): \(currentWeather?.precipitation ?? "")"
    }
    
    func getUVIndex() -> String {
        return "\(AppTexts.uvIndexText): \(currentWeather?.uvIndex ?? "")"
    }
    
    func getSunrise() -> String {
        return "\(AppTexts.sunriseText): \(currentWeather?.sunriseTime.getDateFromDateTime()?.getTime() ?? "")"
    }
    
    func getSunset() -> String {
        return "\(AppTexts.sunsetText): \(currentWeather?.sunsetTime.getDateFromDateTime()?.getTime() ?? "")"
    }
    
    func getFiveDayForecast() -> [WeatherForecastModel] {
        if let currentWeather = currentWeather, let weatherForecasts = currentWeather.weatherForecasts {
            return weatherForecasts
        }
        return []
    }


}

