//
//  WeatherDetailViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/09/25.
//

import SwiftUI

struct WeatherForecast: Identifiable {
    let id = UUID()
    let day: String
    let condition: WeatherCondition
    let temperature: String
}

class WeatherDetailViewModel: ObservableObject {
    
    @Published var weatherCondition: WeatherCondition = WeatherCondition(rawValue: Int.random(in: 1...WeatherCondition.allCases.count)) ?? .clear
    
    func getWeatherBackground() -> LinearGradient {
        weatherCondition.getTheme().getGradient()
    }
    
    func getWeatherIcon() -> String {
        weatherCondition.getIcon()
    }
    
    func getWeatherName() -> String {
        weatherCondition.getName()
    }
    
    func getWeatherTemperature() -> String {
        return "\(Int.random(in: 20...35))°"
    }
    
    func getFiveDayForecast() -> [WeatherForecast] {
        var forecasts: [WeatherForecast] = []
        let conditions = WeatherCondition.allCases
        let calendar = Calendar.current
        let today = Date()
        
        for i in 1...5 {
            if let forecastDate = calendar.date(byAdding: .day, value: i, to: today) {
                let condition = conditions.randomElement() ?? .clear
                let temperatureMin = Int.random(in: 15...30)
                let temperatureMax = Int.random(in: 15...30)
                let forecast = WeatherForecast(day: forecastDate.getDayName(), condition: condition, temperature: "\(temperatureMax)° / \(temperatureMin)°")
                forecasts.append(forecast)
            }
        }
        
        return forecasts
    }

}

