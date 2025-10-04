//
//  OpenMeteoModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 01/10/25.
//

import UIKit

// MARK: - OpenMeteoModel
struct OpenMeteoModel: Codable {
    let latitude: Double
    let longitude: Double
    let generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let currentUnits: CurrentUnits
    let currentWeather: CurrentWeather
    let dailyUnits: DailyUnits
    let daily: Daily
    var place: PlaceDetails?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case currentWeather = "current"
        case dailyUnits = "daily_units"
        case daily
    }
    
    init(latitude: Double, longitude: Double, generationtimeMS: Double, utcOffsetSeconds: Int, timezone: String, timezoneAbbreviation: String, elevation: Int, currentUnits: CurrentUnits, currentWeather: CurrentWeather, dailyUnits: DailyUnits, daily: Daily, place: PlaceDetails) {
        self.latitude = latitude
        self.longitude = longitude
        self.generationtimeMS = generationtimeMS
        self.utcOffsetSeconds = utcOffsetSeconds
        self.timezone = timezone
        self.timezoneAbbreviation = timezoneAbbreviation
        self.elevation = elevation
        self.currentUnits = currentUnits
        self.currentWeather = currentWeather
        self.dailyUnits = dailyUnits
        self.daily = daily
        self.place = place
    }
}

// MARK: - Current
struct CurrentWeather: Codable {
    let time: String
    let interval, temperature2M, relativeHumidity2M: Double
    let apparentTemperature, precipitation: Double
    let weatherCode: Int
    let windSpeed10M: Double

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation
        case weatherCode = "weather_code"
        case windSpeed10M = "wind_speed_10m"
    }
}

// MARK: - CurrentUnits
struct CurrentUnits: Codable {
    let time, interval, temperature2M, relativeHumidity2M: String
    let apparentTemperature, precipitation, weatherCode, windSpeed10M: String

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case precipitation
        case weatherCode = "weather_code"
        case windSpeed10M = "wind_speed_10m"
    }
}

// MARK: - Daily
struct Daily: Codable {
    let time: [String]
    let temperature2MMax, temperature2MMin: [Double]
    let weatherCode: [Int]
    let uvIndexMax: [Double]
    let sunrise, sunset: [String]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case weatherCode = "weather_code"
        case uvIndexMax = "uv_index_max"
        case sunrise, sunset
    }
}

// MARK: - DailyUnits
struct DailyUnits: Codable {
    let time, temperature2MMax, temperature2MMin: String
    let weatherCode, uvIndexMax, sunrise, sunset: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case weatherCode = "weather_code"
        case uvIndexMax = "uv_index_max"
        case sunrise, sunset
    }
}

