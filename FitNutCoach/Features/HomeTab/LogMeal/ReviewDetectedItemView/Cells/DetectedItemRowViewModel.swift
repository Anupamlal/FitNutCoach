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
    
    private func updateMacrosForServing() {
        self.servingSize = self.foodItemModel.servingSize
        self.totalCalories = self.foodItemModel.calories
        self.totalCarbs = self.foodItemModel.carbs
        self.totalProtien = self.foodItemModel.protein
        self.totalFat = self.foodItemModel.fat
    }
    
    func fillUpdatedServingSizes() {
        self.foodItemModel.servingSize = self.servingSize * Double(numberOfServing)
        self.foodItemModel.calories = self.totalCalories * Double(numberOfServing)
        self.foodItemModel.carbs = self.totalCarbs * Double(numberOfServing)
        self.foodItemModel.protein = self.totalProtien * Double(numberOfServing)
        self.foodItemModel.fat = self.totalFat * Double(numberOfServing)
        self.foodItemModel.numberOfServing = numberOfServing
    }
    
    func getConfidenceValue() -> String {
        return "\(Int(self.foodItemModel.confidence * 100))%"
    }
    
    func getSecondLineText() -> String {
        if let measurementUnit = foodItemModel.measurementUnit {
            return "\(self.numberOfServing) \(measurementUnit.rawValue), \(self.foodItemModel.servingSize.formatToOneDecimalPlaces())\(self.foodItemModel.servingUnit ?? "g"), \(self.foodItemModel.calories.formatToOneDecimalPlaces()) \(AppTexts.kcalText)"
        }else {
            return "\(self.numberOfServing) \(AppTexts.servings), \(self.foodItemModel.servingSize.formatToOneDecimalPlaces())\(self.foodItemModel.servingUnit ?? "g"), \(self.foodItemModel.calories.formatToOneDecimalPlaces()) \(AppTexts.kcalText)"
        }
    }
}
