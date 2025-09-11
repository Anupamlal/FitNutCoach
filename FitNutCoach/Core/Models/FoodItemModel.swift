//
//  FoodItemModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI

struct FoodItemModel: Codable {
    let id: String?
    let brand: String?
    var calories: Double
    var carbs: Double
    let confidence: Double
    var fat: Double
    let foodRefId: String?
    let name: String?
    let notes: String?
    var protein: Double
    var servingSize: Double
    let servingUnit: String?
    let tags: String?
    
    init(id: String?, brand: String?, calories: Double, carbs: Double, confidence: Double, fat: Double, foodRefId: String?, name: String?, notes: String?, protein: Double, servingSize: Double, servingUnit: String?, tags: String?) {
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
        self.init(id: UUID().uuidString, brand: nil, calories: 0, carbs: 0, confidence: 0, fat: 0, foodRefId: nil, name: nil, notes: nil, protein: 0, servingSize: 0, servingUnit: nil, tags: nil)
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
    
    init(foodCatalogItem: FoodCatalogItemModel) {
        
        /*
         
         koi v chiz 100g se kam hai to sare macros total weight ke hain, aur agar 100 >= to macros 100gm ke hain
         
         */
        
        let servingSize = foodCatalogItem.servingSize
        let totalSize = foodCatalogItem.totalSize
        
        var totalCalorieInOnServing = 0.0
        var totalProtienInOnServing = 0.0
        var totalCarbsInOnServing = 0.0
        var totalFatInOnServing = 0.0
        
        if (totalSize ?? 0) < 100 && servingSize == totalSize {
            totalCalorieInOnServing = foodCatalogItem.caloriesPer100G ?? 0
            totalProtienInOnServing = foodCatalogItem.proteinPer100G ?? 0
            totalCarbsInOnServing = foodCatalogItem.carbsPer100G ?? 0
            totalFatInOnServing = foodCatalogItem.fatPer100G ?? 0
            
        }else {
            
            let ratio: Double = (servingSize ?? 0)/100
            
            totalCalorieInOnServing = (foodCatalogItem.caloriesPer100G ?? 0) * ratio
            totalProtienInOnServing = (foodCatalogItem.proteinPer100G ?? 0) * ratio
            totalCarbsInOnServing = (foodCatalogItem.carbsPer100G ?? 0) * ratio
            totalFatInOnServing = (foodCatalogItem.fatPer100G ?? 0) * ratio
            
        }
        
        self.id = foodCatalogItem.id
        self.brand = foodCatalogItem.brand
        self.confidence = foodCatalogItem.confidence
        self.foodRefId = nil
        self.name = foodCatalogItem.name
        self.notes = nil
        self.servingSize = foodCatalogItem.servingSize ?? 0
        self.servingUnit = foodCatalogItem.servingSizeUnit ?? ""
        self.tags = nil
        
        self.calories = totalCalorieInOnServing
        self.protein = totalProtienInOnServing
        self.carbs = totalCarbsInOnServing
        self.fat = totalFatInOnServing
        
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
    
    func getProtienPercentageInTotalCalorie() -> String {
        let fatPercent = (self.protein / self.calories) * 100
        return "\(Int(fatPercent))%"
    }
    
    func getCarbsPercentageInTotalCalorie() -> String {
        let fatPercent = (self.carbs / self.calories) * 100
        return "\(Int(fatPercent))%"
    }
    
    func getFatPercentageInTotalCalorie() -> String {
        let fatPercent = (self.fat / self.calories) * 100
        return "\(Int(fatPercent))%"
    }
}
