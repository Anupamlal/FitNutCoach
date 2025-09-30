//
//  MealManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 31/08/25.
//

import SwiftUI
import CoreData

class MealManager {
    
    private class func getMeal(date: Date, mealType: MealType, viewContext: NSManagedObjectContext) async -> Meal? {
        let startOfDate = date.getStartOfDate()
        
        let fetchRequest = Meal.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "date == %@ AND mealType == %@", startOfDate as NSDate, mealType.rawValue)
        fetchRequest.fetchLimit = 1
                
        if let meal = try? viewContext.fetch(fetchRequest).first {
            return meal
        }
        
        return nil
    }

    class func getMealFor(date: Date, mealType: MealType, viewContext: NSManagedObjectContext) async -> MealModel? {
        
        if let meal = await getMeal(date: date, mealType: mealType, viewContext: viewContext) {
            return MealModel(meal: meal)
        }
        
        return nil
    }
    
    class func deleteFoodItem(date: Date, foodItem: FoodItemModel, mealType: MealType, viewContext: NSManagedObjectContext) async -> Bool {
        if let meal = await getMeal(date: date, mealType: mealType, viewContext: viewContext) {
            if let foodItems = meal.foodItems as? Set<FoodItem> {
                if let foodItemToDelete = foodItems.first(where: {$0.id == foodItem.id}) {
                    meal.removeFromFoodItems(foodItemToDelete)
                    do {
                        try viewContext.save()
                        return true
                    } catch {
                        print("Failed to delete food item: \(error)")
                        return false
                    }
                }
            }
        }
        return false
    }

}
