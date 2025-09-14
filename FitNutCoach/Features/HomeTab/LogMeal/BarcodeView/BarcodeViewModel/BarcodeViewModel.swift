//
//  BarcodeViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 07/09/25.
//

import UIKit

class BarcodeViewModel: ObservableObject {

    @Published var isBarcodeDetected = false
    @Published var barcodeValue: String = ""
    @Published var isSessionRunning: Bool = true
    @Published var isManualEntryOpen: Bool = false
    @Published var mealType: MealType
    
    init(mealType: MealType) {
        self.mealType = mealType
    }
    
    func loadAllFoodCatalogData(foodCatalogManager: FoodCatalogManager) {
        Task {
            _ = await foodCatalogManager.loadAllFoodCatalogFromServer()
            await foodCatalogManager.loadData()
        }
    }
}
