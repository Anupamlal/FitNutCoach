//
//  AppEnvironment.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 23/08/25.
//


import Foundation

final class AppEnvironment: ObservableObject {
    // Stubs for now; we’ll fill them in next phases.
    // let mealsStore: MealsStore
    // let weatherService: WeatherService
    // ...
}

extension AppEnvironment {
    static let preview = AppEnvironment()
    static let live = AppEnvironment()
}
