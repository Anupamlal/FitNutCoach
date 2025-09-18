//
//  FoodItemModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI

struct FoodItemModel: Codable, Equatable, Hashable {
    let id: String?
    let brand: String?
    var calories: Double
    var carbs: Double
    let confidence: Double
    let createdAt: Date?
    var fat: Double
    let foodRefId: String?
    let imageUrl: String?
    let measurementUnit: MeasurementUnit?
    let name: String?
    let notes: String?
    var protein: Double
    var servingSize: Double
    let servingUnit: String?
    let tags: String?
    var numberOfServing: Int
    
    init(id: String?, brand: String?, calories: Double, carbs: Double, confidence: Double, createdAt: Date?, fat: Double, foodRefId: String?, imageUrl: String?, measurementUnit: MeasurementUnit?, name: String?, notes: String?, protein: Double, servingSize: Double, servingUnit: String?, tags: String?, numberOfServing: Int) {
        self.id = id
        self.brand = brand
        self.calories = calories
        self.carbs = carbs
        self.confidence = confidence
        self.createdAt = createdAt
        self.fat = fat
        self.foodRefId = foodRefId
        self.imageUrl = imageUrl
        self.measurementUnit = measurementUnit
        self.name = name
        self.notes = notes
        self.protein = protein
        self.servingSize = servingSize
        self.servingUnit = servingUnit
        self.tags = tags
        self.numberOfServing = numberOfServing
    }
    
    init() {
        self.init(id: UUID().uuidString, brand: nil, calories: 0, carbs: 0, confidence: 0, createdAt: Date(), fat: 0, foodRefId: nil, imageUrl: nil, measurementUnit: nil, name: nil, notes: nil, protein: 0, servingSize: 0, servingUnit: nil, tags: nil, numberOfServing: 1)
    }

    init(foodItem: FoodItem, isRequiredNewId: Bool = false) {
        self.id = isRequiredNewId ? UUID().uuidString : foodItem.id
        self.brand = foodItem.brand
        self.calories = foodItem.calories
        self.carbs = foodItem.carbs
        self.confidence = foodItem.confidence
        self.createdAt = isRequiredNewId ? Date() : foodItem.createdAt
        self.fat = foodItem.fat
        self.foodRefId = foodItem.foodRefId
        self.imageUrl = foodItem.imageUrl
        self.measurementUnit = MeasurementUnit(rawValue: foodItem.measurementUnit ?? "")
        self.name = foodItem.name
        self.notes = foodItem.notes
        self.protein = foodItem.protein
        self.servingSize = foodItem.servingSize
        self.servingUnit = foodItem.servingUnit
        self.tags = foodItem.tags
        self.numberOfServing = Int(foodItem.numberOfServing)
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
        
        self.id = UUID().uuidString
        self.brand = foodCatalogItem.brand
        self.confidence = foodCatalogItem.confidence
        self.createdAt = Date()
        self.foodRefId = foodCatalogItem.id
        self.measurementUnit = foodCatalogItem.measurementUnit
        self.imageUrl = foodCatalogItem.imageUrl
        self.name = foodCatalogItem.name
        self.notes = nil
        self.servingSize = foodCatalogItem.servingSize ?? 0
        self.servingUnit = foodCatalogItem.servingSizeUnit ?? ""
        self.tags = nil
        
        self.calories = totalCalorieInOnServing
        self.protein = totalProtienInOnServing
        self.carbs = totalCarbsInOnServing
        self.fat = totalFatInOnServing
        self.numberOfServing = 1
    }
    
    func fillFoodItem(foodItem: FoodItem) {
        foodItem.id = self.id
        foodItem.brand = self.brand
        foodItem.calories = self.calories
        foodItem.carbs = self.carbs
        foodItem.confidence = self.confidence
        foodItem.createdAt = self.createdAt
        foodItem.fat = self.fat
        foodItem.foodRefId = self.foodRefId
        foodItem.measurementUnit = self.measurementUnit?.rawValue
        foodItem.imageUrl = self.imageUrl
        foodItem.name = self.name
        foodItem.notes = self.notes
        foodItem.protein = self.protein
        foodItem.servingSize = self.servingSize
        foodItem.servingUnit = self.servingUnit
        foodItem.tags = self.tags
        foodItem.numberOfServing = Int16(self.numberOfServing)
    }
    
    func getProtienPercentageInTotalCalorie() -> String {
        let proteinPercent = (self.protein / self.calories) * 100
        return "\(Int(proteinPercent))%"
    }
    
    func getCarbsPercentageInTotalCalorie() -> String {
        let carbsPercent = (self.carbs / self.calories) * 100
        return "\(Int(carbsPercent))%"
    }
    
    func getFatPercentageInTotalCalorie() -> String {
        let fatPercent = (self.fat / self.calories) * 100
        return "\(Int(fatPercent))%"
    }
}
