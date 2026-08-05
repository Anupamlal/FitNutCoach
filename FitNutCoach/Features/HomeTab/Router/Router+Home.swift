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
    case reviewImageDetection(ReviewDetectedItemConfig)
    
    case weatherDetail
    case allNudges
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
            
        case .reviewImageDetection(let reviewDetectedItemConfig):
            ReviewDetectedItemView(reviewDetectedItemConfig: reviewDetectedItemConfig)
            
        case .weatherDetail:
            WeatherDetailView()
            
        case .allNudges:
            AllNudgesViewWrapper()
        }
    }
}

private struct AllNudgesViewWrapper: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    
    var body: some View {
        AllNudgesView(nudgeManager: appRootManager.nudgeManager)
    }
}
