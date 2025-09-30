//
//  WeatherConfig.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/09/25.
//


import SwiftUI

enum WeatherCondition: Int, CaseIterable {
    case clear = 1
    case partlyCloudy, cloudy
    case rain, drizzle, thunderstorm
    case snow
    case mist, fog
    
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
        case .mist: return AppTexts.mistText
        case .fog: return AppTexts.fogText
        }
    }
    
    func getTheme() -> WeatherTheme {
        switch self {
        case .clear, .partlyCloudy: return .sunny
        case .cloudy, .rain, .drizzle, .thunderstorm: return .rainy
        case .snow, .mist, .fog: return .winter
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

struct WeatherGradients {
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
    case mist = "💨"
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
        case .mist: return WeatherIcon.mist.rawValue
        case .fog: return WeatherIcon.fog.rawValue
        }
    }
}
