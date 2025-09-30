//
//  WeatherDetailView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/09/25.
//

import SwiftUI

struct WeatherDetailView: View {
    
    @StateObject var weatherDetailVM = WeatherDetailViewModel()
    
    var body: some View {
        ZStack {
            weatherDetailVM.getWeatherBackground()
                .ignoresSafeArea()
                .overlay(Color.white.opacity(0.12))
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(weatherDetailVM.getWeatherIcon()) \(weatherDetailVM.getWeatherName())")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 24, weight: .semibold))
                    
                    Spacer()
                    
                    Text(weatherDetailVM.getWeatherTemperature())
                        .foregroundStyle(Color.white)
                        .font(.system(size: 64, weight: .bold))
                }
                .padding(.bottom, 10)
                
                Text("Mumbai, India")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.bottom, 7)
                
                HStack(spacing: 20) {
                    Text("Feels like: 27°C")
                    Text("Humidity: 78%")
                }
                .foregroundStyle(Color.white)
                .font(.system(size: 16, weight: .medium))
                .padding(.bottom, 30)
                
                Card {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Current Conditions")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Feels Like: 27°C")
                                Text("Humidity: 62%")
                                Text("Wind Speed: 11 km/h")
                                Text("UV Index: 5 (Moderate)")
                                
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Precipitation: 0.0 mm")
                                Text("Sunrise: 6:15 AM")
                                Text("Sunset: 6:48 PM")
                            }
                        }
                        .foregroundStyle(Color.textSecondary)
                        .font(.system(size: 16, weight: .regular))
                    }
                }
                .padding(.bottom, 20)
                
                Card {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("5-Day Forecast")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                        
                        ForEach(weatherDetailVM.getFiveDayForecast(), id: \.id) { forecast in
                            HStack {
                                Text(forecast.day)
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(width: 50, alignment: .leading)
                                
                                Spacer()
                                    .frame(maxWidth: 20)
                                
                                Text(forecast.condition.getIcon())
                                Text(forecast.condition.getName())
                                    .font(.system(size: 16, weight: .regular))
                                
                                Spacer()
                                
                                Text(forecast.temperature)
                                    .font(.system(size: 16, weight: .regular))
                                    .frame(alignment: .leading)
                                    .frame(maxWidth: 70, alignment: .leading)
                            }
                            .foregroundStyle(Color.textSecondary)
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
        }
        .withCustomBackButton(withTitle: "", backButtonTint: .white)
    }
}

#Preview {
    NavigationStack {
        WeatherDetailView()
    }
}
