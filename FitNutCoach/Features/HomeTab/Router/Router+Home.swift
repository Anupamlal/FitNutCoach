//
//  Router+Home.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 19/09/25.
//

import SwiftUI

enum HomeRouter: Hashable {
    case logMeal
    case addFoodItem(selectedMealType: MealType)
    case reviewFoodItem(ReviewItemConfig)
    case profile
    case reviewImageDetection(ReviewDetectedItemConfig)
    
    case weatherDetail
}

extension Router {
    
    @ViewBuilder
    func destination(for homeRouter: HomeRouter) -> some View {
        
        switch homeRouter {
        case .logMeal:
            LogMealView()
            
        case .addFoodItem(let selectedMealType):
            AddFoodItemView(selectedMealType: selectedMealType)
            
        case .reviewFoodItem(let reviewItemConfig):
            ReviewItemView(reviewItemConfig: reviewItemConfig)
            
        case .profile:
            ProfileView()
            
        case .reviewImageDetection(let reviewDetectedItemConfig):
            ReviewDetectedItemView(reviewDetectedItemConfig: reviewDetectedItemConfig)
            
        case .weatherDetail:
            WeatherDetailView()
            
        }
    }
}
