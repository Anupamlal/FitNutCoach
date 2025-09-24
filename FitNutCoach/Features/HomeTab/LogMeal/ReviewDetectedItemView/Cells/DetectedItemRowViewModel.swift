//
//  DetectedItemRowViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import UIKit

class DetectedItemRowViewModel: ObservableObject {

    @Published var foodItemModel: FoodItemModel
    @Published var numberOfServing: Int = 1
    @Published var servingSize: Double = 0
    @Published var totalCalories: Double = 0
    @Published var totalProtien: Double = 0
    @Published var totalCarbs: Double = 0
    @Published var totalFat: Double = 0
    @Published var isSelected: Bool = false
    
    init(foodItemModel: FoodItemModel) {
        self.foodItemModel = foodItemModel
        updateMacrosForServing()
    }
    
    func updateMacrosForServing() {
        self.servingSize = (self.foodItemModel.servingSize) * Double(numberOfServing)
        self.totalCalories = (self.foodItemModel.calories) * Double(numberOfServing)
        self.totalCarbs = (self.foodItemModel.carbs) * Double(numberOfServing)
        self.totalProtien = (self.foodItemModel.protein) * Double(numberOfServing)
        self.totalFat = (self.foodItemModel.fat) * Double(numberOfServing)
    }
    
    func fillUpdatedServingSizes() {
        self.foodItemModel.servingSize = self.servingSize
        self.foodItemModel.calories = self.totalCalories
        self.foodItemModel.carbs = self.totalCarbs
        self.foodItemModel.protein = self.totalProtien
        self.foodItemModel.fat = self.totalFat
        self.foodItemModel.numberOfServing = numberOfServing
    }
    
    func getConfidenceValue() -> String {
        return "\(Int(self.foodItemModel.confidence * 100))%"
    }
    
    func getSecondLineText() -> String {
        if let measurementUnit = foodItemModel.measurementUnit {
            return "\(self.numberOfServing) \(measurementUnit.rawValue), \(self.servingSize.formatToOneDecimalPlaces())\(self.foodItemModel.servingUnit ?? "g"), \(self.totalCalories.formatToOneDecimalPlaces()) \(AppTexts.kcalText)"
        }else {
            return "\(self.numberOfServing) \(AppTexts.servings), \(self.servingSize.formatToOneDecimalPlaces())\(self.foodItemModel.servingUnit ?? "g"), \(self.totalCalories.formatToOneDecimalPlaces()) \(AppTexts.kcalText)"
        }
    }
}
