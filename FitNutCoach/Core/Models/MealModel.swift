//
//  MealModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//


import SwiftUI
import CoreData

enum MealType: String, Codable, CaseIterable {
    case breakfast, lunch, snack, dinner
    
    func getDisplayName() -> String {
        switch self {
        case .breakfast:
            return AppTexts.breakFastText
        case .lunch:
            return AppTexts.lunchText
        case .dinner:
            return AppTexts.dinnerText
        case .snack:
            return AppTexts.snacksText
        }
    }
}

enum MealSourceType: String, Codable {
    case manual, photo, barcode, search
}

enum MeasurementUnit: String, Codable {
    case piece, cup, large, slice, bowl, tsp
}

struct MealModel: Codable {
    let id: String?
    let aiConfidence: Double
    let createdAt: Date?
    let date: Date?
    let mealType: MealType?
    let notes: String?
    let photoId: String?
    let mealSource: MealSourceType?
    var updatedAt: Date?
    var foodItems: [FoodItemModel]?
    
    init(id: String?, aiConfidence: Double, createdAt: Date?, date: Date?, mealType: MealType?, notes: String?, photoId: String?, mealSource: MealSourceType?, updatedAt: Date?, foodItems: [FoodItemModel]?) {
        self.id = id
        self.aiConfidence = aiConfidence
        self.createdAt = createdAt
        self.date = date
        self.mealType = mealType
        self.notes = notes
        self.photoId = photoId
        self.mealSource = mealSource
        self.updatedAt = updatedAt
        self.foodItems = foodItems
    }
    
    init() {
        self.init(id: UUID().uuidString, aiConfidence: 0, createdAt: nil, date: nil, mealType: nil, notes: nil, photoId: nil, mealSource: nil, updatedAt: nil, foodItems: nil)
    }
    
    init(meal: Meal) {
        self.id = meal.id
        self.aiConfidence = meal.aiConfidence
        self.createdAt = meal.createdAt
        self.date = meal.date
        self.mealType = MealType(rawValue: meal.mealType ?? "")
        self.notes = meal.notes
        self.photoId = meal.photoId
        self.mealSource = MealSourceType(rawValue: meal.source ?? "")
        self.updatedAt = meal.updatedAt
        
        if let foodItems = meal.foodItems as? Set<FoodItem> {
            
            let foodItemsArr = Array(foodItems).sorted { ($0.createdAt ?? Date()) < ($1.createdAt ?? Date()) }
            
            for foodItem in foodItemsArr {
                if self.foodItems == nil {
                    self.foodItems = []
                }
                self.foodItems?.append(FoodItemModel(foodItem: foodItem))
            }
        }else {
            self.foodItems = nil
        }
        
    }
    
    func fillMeal(meal: Meal, context: NSManagedObjectContext) {
        meal.id = self.id
        meal.aiConfidence = self.aiConfidence
        meal.createdAt = self.createdAt
        meal.date = self.date?.getStartOfDate()
        meal.mealType = self.mealType?.rawValue
        meal.notes = self.notes
        meal.photoId = self.photoId
        meal.source = self.mealSource?.rawValue
        meal.updatedAt = self.updatedAt
        
        if let foodItems = self.foodItems {
            var allFoodItem = Set<FoodItem>()
            
            for foodItem in foodItems {
                let foodItemCD = FoodItem(context: context)
                foodItem.fillFoodItem(foodItem: foodItemCD)
                
                allFoodItem.insert(foodItemCD)
            }
            
            meal.foodItems = allFoodItem as NSSet
        }
    }
}
