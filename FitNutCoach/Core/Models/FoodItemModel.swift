//
//  FoodItemModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI

struct FoodItemModel: Codable {
    let id: UUID?
    let brand: String?
    let calories: Double
    let carbs: Double
    let confidence: Double
    let fat: Double
    let foodRefId: String?
    let name: String?
    let notes: String?
    let protein: Double
    let servingSize: Double
    let servingUnit: String?
    let tags: String?
    
    init(id: UUID?, brand: String?, calories: Double, carbs: Double, confidence: Double, fat: Double, foodRefId: String?, name: String?, notes: String?, protein: Double, servingSize: Double, servingUnit: String?, tags: String?) {
        self.id = id
        self.brand = brand
        self.calories = calories
        self.carbs = carbs
        self.confidence = confidence
        self.fat = fat
        self.foodRefId = foodRefId
        self.name = name
        self.notes = notes
        self.protein = protein
        self.servingSize = servingSize
        self.servingUnit = servingUnit
        self.tags = tags
    }
    
    init() {
        self.init(id: UUID(), brand: nil, calories: 0, carbs: 0, confidence: 0, fat: 0, foodRefId: nil, name: nil, notes: nil, protein: 0, servingSize: 0, servingUnit: nil, tags: nil)
    }

    init(foodItem: FoodItem) {
        self.id = foodItem.id
        self.brand = foodItem.brand
        self.calories = foodItem.calories
        self.carbs = foodItem.carbs
        self.confidence = foodItem.confidence
        self.fat = foodItem.fat
        self.foodRefId = foodItem.foodRefId
        self.name = foodItem.name
        self.notes = foodItem.notes
        self.protein = foodItem.protein
        self.servingSize = foodItem.servingSize
        self.servingUnit = foodItem.servingUnit
        self.tags = foodItem.tags
    }
    
    func fillFoodItem(foodItem: FoodItem) {
        foodItem.id = self.id
        foodItem.brand = self.brand
        foodItem.calories = self.calories
        foodItem.carbs = self.carbs
        foodItem.confidence = self.confidence
        foodItem.fat = self.fat
        foodItem.foodRefId = self.foodRefId
        foodItem.name = self.name
        foodItem.notes = self.notes
        foodItem.protein = self.protein
        foodItem.servingSize = self.servingSize
        foodItem.servingUnit = self.servingUnit
        foodItem.tags = self.tags
    }
}
