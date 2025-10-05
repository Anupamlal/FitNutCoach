//
//  WeatherDetailView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/09/25.
//

import SwiftUI

struct WeatherDetailView: View {
    
    @StateObject var weatherDetailVM: WeatherDetailViewModel =  WeatherDetailViewModel()
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        ZStack {
            if let gradeint = weatherDetailVM.getWeatherBackground() {
                gradeint
                    .ignoresSafeArea()
                    .overlay(Color.white.opacity(0.12))
            }
            
            ScrollView(content: {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(weatherDetailVM.getCurrentWeather())
                            .foregroundStyle(Color.white)
                            .font(.system(size: 24, weight: .semibold))
                        
                        Spacer()
                        
                        Text(weatherDetailVM.getWeatherTemperature())
                            .foregroundStyle(Color.white)
                            .font(.system(size: 64, weight: .bold))
                    }
                    .padding(.bottom, 10)
                    
                    Text(weatherDetailVM.getPlaceName())
                        .foregroundStyle(Color.white)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.bottom, 7)
                    
                    HStack(spacing: 20) {
                        Text(weatherDetailVM.getFeelsLike())
                        Text(weatherDetailVM.getHumidity())
                    }
                    .foregroundStyle(Color.white)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.bottom, 7)
                    
                    Text(weatherDetailVM.getLastUpdateTime())
                        .foregroundStyle(Color.white)
                        .font(.system(size: 14, weight: .regular))
                        .italic()
                        .padding(.bottom, 30)
                    
                    Card {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(AppTexts.currentConditionsText)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.textPrimary)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(weatherDetailVM.getFeelsLike())
                                    Text(weatherDetailVM.getHumidity())
                                    Text(weatherDetailVM.getWindSpeed())
                                    Text(weatherDetailVM.getUVIndex())
                                    
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(weatherDetailVM.getPrecipitation())
                                    Text(weatherDetailVM.getSunrise())
                                    Text(weatherDetailVM.getSunset())
                                }
                            }
                            .foregroundStyle(Color.textSecondary)
                            .font(.system(size: 16, weight: .regular))
                        }
                    }
                    .padding(.bottom, 20)
                    
                    if weatherDetailVM.getFiveDayForecast().count > 0 {
                        Card {
                            VStack(alignment: .leading, spacing: 15) {
                                Text(AppTexts.fiveDayForecastText)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                
                                ForEach(weatherDetailVM.getFiveDayForecast(), id: \.id) { forecast in
                                    HStack {
                                        Text(forecast.dayName)
                                            .font(.system(size: 16, weight: .medium))
                                            .frame(width: 50, alignment: .leading)
                                        
                                        Spacer()
                                            .frame(maxWidth: 20)
                                        
                                        Text(forecast.weatherCondition.getIcon())
                                        Text(forecast.weatherCondition.getName())
                                            .font(.system(size: 16, weight: .regular))
                                        
                                        Spacer()
                                        
                                        Text("\(forecast.minTemperature) / \(forecast.maxTemperature)")
                                            .font(.system(size: 16, weight: .regular))
                                            .frame(alignment: .leading)
                                            .frame(maxWidth: 100, alignment: .leading)
                                    }
                                    .foregroundStyle(Color.textSecondary)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                }
            })
            .refreshable {
                _ = await weatherDetailVM.pullToRefresh()
            }
            .padding(.horizontal, 20)
        }
        .withCustomBackButton(withTitle: "", backButtonTint: .white)
        .onFirstAppear {
            weatherDetailVM.onAppear(weatherManager: self.weatherManager)
        }
    }
}

#Preview {
    NavigationStack {
        WeatherDetailView()
    }
}
