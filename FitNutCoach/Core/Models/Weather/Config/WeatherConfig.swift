//
//  WeatherConfig.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/09/25.
//


import SwiftUI

enum WeatherCondition: Int, CaseIterable, Codable{
    case clear = 1
    case partlyCloudy, cloudy
    case rain, drizzle, thunderstorm
    case snow
    case fog
    
    func getIcon() -> String {
        WeatherIcon.clear.getIcon(for: self)
    }
    
    func getName() -> String {
        switch self {
        case .clear: return AppTexts.clearText
        case .partlyCloudy: return AppTexts.partlyCloudyText
        case .cloudy: return AppTexts.cloudyText
        case .rain: return AppTexts.rainText
        case .drizzle: return AppTexts.drizzleText
        case .thunderstorm: return AppTexts.thunderstormText
        case .snow: return AppTexts.snowText
        case .fog: return AppTexts.fogText
        }
    }
    
    func getTheme() -> WeatherTheme {
        switch self {
        case .clear, .partlyCloudy: return .sunny
        case .cloudy, .rain, .drizzle, .thunderstorm: return .rainy
        case .snow, .fog: return .winter
        }
    }
    
    static func from(weatherCode: Int) -> WeatherCondition {
        
        switch weatherCode {
        case 0, 1:
            return .clear
            
        case 2:
            return .partlyCloudy
            
        case 3:
            return .cloudy
            
        case 45, 48:
            return .fog
            
        case 51, 53, 55, 56, 57:
            return .drizzle
            
        case 61, 63, 65, 66, 67, 80, 81, 82:
            return .rain
            
        case 71, 73, 75, 77, 85, 86:
            return .snow
      
        case 95, 96, 99:
            return .thunderstorm
            
        default:
            return .clear
        }
    }
}

enum WeatherTheme {
    case sunny, winter, rainy
    
    func getGradient() -> LinearGradient {
        let colors: [Color]
        switch self {
        case .sunny:  colors = WeatherGradients.sunny
        case .winter: colors = WeatherGradients.winter
        case .rainy:  colors = WeatherGradients.rainy
        }
        return LinearGradient(gradient: Gradient(colors: colors),
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
    }
}

enum WeatherGradients {
    static let sunny  = [Color(hex: 0x56CCF2), Color(hex: 0x2F80ED)]          // Classic iOS Sky
    static let winter = [Color(hex: 0xBBD2C5), Color(hex: 0x536976)]          // Arctic Dawn A1C4FD → #C2E9FB
    static let rainy  = [Color(hex: 0x4B79A1), Color(hex: 0x283E51)]          // Rain Sky
}

enum WeatherIcon: String {
    case clear = "☀️"
    case partlyCloudy = "⛅"
    case cloudy = "☁️"
    case rain = "🌧️"
    case drizzle = "🌦️"
    case thunderstorm = "⛈️"
    case snow = "❄️"
    case fog = "🌬️"
    
    func getIcon(for condition: WeatherCondition) -> String {
        switch condition {
        case .clear: return WeatherIcon.clear.rawValue
        case .partlyCloudy: return WeatherIcon.partlyCloudy.rawValue
        case .cloudy: return WeatherIcon.cloudy.rawValue
        case .rain: return WeatherIcon.rain.rawValue
        case .drizzle: return WeatherIcon.drizzle.rawValue
        case .thunderstorm: return WeatherIcon.thunderstorm.rawValue
        case .snow: return WeatherIcon.snow.rawValue
        case .fog: return WeatherIcon.fog.rawValue
        }
    }
}

enum UVIndex {
    case low, moderate, high, veryHigh, extreme
    
    static func from(uvi: Double) -> UVIndex? {
        switch uvi {
        case 0..<3: return .low
        case 3..<6: return .moderate
        case 6..<8: return .high
        case 8..<11: return .veryHigh
        default: return .extreme
        }
    }
    
    func getName() -> String {
        switch self {
        case .low: return AppTexts.uvLowText
        case .moderate: return AppTexts.uvModerateText
        case .high: return AppTexts.uvHighText
        case .veryHigh: return AppTexts.uvVeryHighText
        case .extreme: return AppTexts.uvExtremeText
        }
    }

}
