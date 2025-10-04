//
//  WeatherModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 02/10/25.
//

import SwiftUI
import CoreData

struct WeatherModel: Codable {
    
    let id: String?
    let latitude: Double
    let longitude: Double
    let date: Date
    let updatedAt: Date?
    
    let cityName: String?
    let state: String?
    let country: String?
    let weatherCondition: WeatherCondition
    let temperature: String
    let feelsLikeTemperature: String
    let humidity: String
    let windSpeed: String
    let uvIndex: String
    let precipitation: String
    let sunriseTime: String
    let sunsetTime: String
    var weatherForecasts: [WeatherForecastModel]?
    
    init(id: String?, latitude: Double, longitude: Double, date: Date, updatedAt: Date?, cityName: String?, state: String? = nil, country: String?, weatherCondition: WeatherCondition, temperature: String, feelsLikeTemperature: String, humidity: String, windSpeed: String, uvIndex: String, precipitation: String, sunriseTime: String, sunsetTime: String) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.updatedAt = updatedAt
        self.cityName = cityName
        self.state = state
        self.country = country
        self.weatherCondition = weatherCondition
        self.temperature = temperature
        self.feelsLikeTemperature = feelsLikeTemperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.uvIndex = uvIndex
        self.precipitation = precipitation
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
    }
    
    init() {
        self.init(id: nil, latitude: 0, longitude: 0, date: .init(), updatedAt: nil, cityName: nil, state: nil, country: nil, weatherCondition: .clear, temperature: "", feelsLikeTemperature: "", humidity: "", windSpeed: "", uvIndex: "", precipitation: "", sunriseTime: "", sunsetTime: "")
    }
    
    init(meteoModel: OpenMeteoModel) {
        self.id = UUID().uuidString
        self.latitude = meteoModel.place?.latitude ?? meteoModel.latitude
        self.longitude = meteoModel.place?.longitude ?? meteoModel.longitude
        self.date = Date().getStartOfDate()
        self.updatedAt = Date()
        
        self.cityName = meteoModel.place?.name
        self.state = meteoModel.place?.state
        self.country = meteoModel.place?.country
        self.weatherCondition = WeatherCondition.from(weatherCode: meteoModel.currentWeather.weatherCode)
        
        self.temperature = "\(meteoModel.currentWeather.temperature2M)°"
        self.windSpeed = "\(meteoModel.currentWeather.windSpeed10M) \(meteoModel.currentUnits.windSpeed10M)"

        self.feelsLikeTemperature = "\(meteoModel.currentWeather.apparentTemperature)°"
        self.humidity = "\(meteoModel.currentWeather.relativeHumidity2M)\(meteoModel.currentUnits.relativeHumidity2M)"
        
        if let uvIndexValue = meteoModel.daily.uvIndexMax.first, let uvIndexDescription = UVIndex.from(uvi: uvIndexValue)?.getName() {
            
            self.uvIndex = "\(uvIndexValue) (\(uvIndexDescription))"
            
        }else {
            self.uvIndex = ""
        }
        
        self.precipitation = "\(meteoModel.currentWeather.precipitation) \(meteoModel.currentUnits.precipitation)"
        self.sunriseTime = meteoModel.daily.sunrise.first ?? ""
        self.sunsetTime = meteoModel.daily.sunset.first ?? ""

        for (index,forecast) in meteoModel.daily.time.enumerated() {
            
            if index == 0 {
                continue
            }
            let date = forecast.getDateFromDate() ?? Date()
            let weatherCondition = WeatherCondition.from(weatherCode: meteoModel.daily.weatherCode[index])
            let maxTemp = "\(meteoModel.daily.temperature2MMax[index])°"
            let minTemp = "\(meteoModel.daily.temperature2MMin[index])°"
                
            let weatherForecast = WeatherForecastModel(date: date, weatherCondition: weatherCondition, maxTemperature: maxTemp, minTemperature: minTemp)
            
            if self.weatherForecasts == nil {
                self.weatherForecasts = []
            }
            self.weatherForecasts?.append(weatherForecast)
        }
    }
    
    init(with weather: Weather) {
        self.id = weather.id
        self.latitude = weather.latitude
        self.longitude = weather.longitude
        self.date = weather.date ?? Date()
        self.updatedAt = weather.updatedAt
        
        self.cityName = weather.cityName ?? ""
        self.state = weather.state ?? ""
        self.country = weather.country ?? ""
        self.weatherCondition = WeatherCondition(rawValue: Int(weather.weatherCondition)) ?? .clear
        
        self.temperature = weather.temperature ?? ""
        self.feelsLikeTemperature = weather.feelsLikeTemperature ?? ""
        self.humidity = weather.humidity ?? ""
        self.windSpeed = weather.windSpeed ?? ""
        self.uvIndex = weather.uvIndex ?? ""
        self.precipitation = weather.precipitation ?? ""
        self.sunriseTime = weather.sunriseTime ?? ""
        self.sunsetTime = weather.sunsetTime ?? ""
        
        if let forecasts = weather.forecasts?.allObjects as? [WeatherForecast] {
            self.weatherForecasts = forecasts.map {
                WeatherForecastModel(with: $0)
            }
            
            self.weatherForecasts?.sort(by: { $0.date < $1.date })
        }
    }
    
    func fillWeather(weather: Weather, context: NSManagedObjectContext) {
        weather.id = self.id
        weather.latitude = self.latitude
        weather.longitude = self.longitude
        weather.date = self.date
        weather.updatedAt = self.updatedAt
        
        weather.cityName = self.cityName
        weather.state = self.state
        weather.country = self.country
        weather.weatherCondition = Int16(self.weatherCondition.rawValue)
        
        weather.temperature = self.temperature
        weather.feelsLikeTemperature = self.feelsLikeTemperature
        weather.humidity = self.humidity
        weather.windSpeed = self.windSpeed
        weather.uvIndex = self.uvIndex
        weather.precipitation = self.precipitation
        weather.sunriseTime = self.sunriseTime
        weather.sunsetTime = self.sunsetTime
        
        if let forecasts = self.weatherForecasts {
            let forecastSet = NSMutableSet()
            for forecast in forecasts {
                let weatherForecast = WeatherForecast(context: context)
                weatherForecast.id = forecast.id
                weatherForecast.date = forecast.date
                weatherForecast.weatherCondition = Int16(forecast.weatherCondition.rawValue)
                weatherForecast.maxTemperature = forecast.maxTemperature
                weatherForecast.minTemperature = forecast.minTemperature
                forecastSet.add(weatherForecast)
            }
            weather.forecasts = forecastSet
        }
    }
}

struct WeatherForecastModel: Codable {
    let id: String
    let date: Date
    let weatherCondition: WeatherCondition
    let maxTemperature: String
    let minTemperature: String
    let dayName: String
    
    init(date: Date, weatherCondition: WeatherCondition, maxTemperature: String, minTemperature: String) {
        self.id = UUID().uuidString
        self.date = date
        self.weatherCondition = weatherCondition
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        self.dayName = date.getDayName(timeZone: TimeZone(identifier: "UTC"))
    }
    
    init(with weatherForecast: WeatherForecast) {
        self.id = weatherForecast.id ?? UUID().uuidString
        self.date = weatherForecast.date ?? Date()
        self.weatherCondition = WeatherCondition(rawValue: Int(weatherForecast.weatherCondition)) ?? .clear
        self.maxTemperature = weatherForecast.maxTemperature ?? ""
        self.minTemperature = weatherForecast.minTemperature ?? ""
        self.dayName = date.getDayName(timeZone: TimeZone(identifier: "UTC"))
    }

}
