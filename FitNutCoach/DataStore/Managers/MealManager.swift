//
//  MealManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 31/08/25.
//

import SwiftUI
import CoreData

class MealManager {

    class func getMealFor(date: Date, mealType: MealType, viewContext: NSManagedObjectContext) async -> MealModel? {
        let startOfDate = date.getStartOfDate()
        
        let fetchRequest = Meal.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "date == %@ AND mealType == %@", startOfDate as NSDate, mealType.rawValue)
        fetchRequest.fetchLimit = 1
                
        if let meal = try? viewContext.fetch(fetchRequest).first {
            return MealModel(meal: meal)
        }
        
        return nil
    }
}
