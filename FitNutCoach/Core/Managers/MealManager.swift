//
//  MealManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 31/08/25.
//

import SwiftUI
import Combine
import CoreData

class MealManager: ObservableObject {
    
    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    
    private let dailyActiviyManager: DailyActivityManager
    
    init(container: NSPersistentContainer, dailyActiviyManager: DailyActivityManager) {
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.dailyActiviyManager = dailyActiviyManager
    }
    
    func addMeal(meal: MealModel) async {
        if let date = meal.date, let dayActivity = await dailyActiviyManager.loadData(date: date) {
            
            let mealCD = Meal(context: self.bgContext)
            
            meal.fillMeal(meal: mealCD, context: self.bgContext)
            mealCD.dailyActivity = dayActivity
            
            
            let mealCalories = meal.foodItems?.reduce(0) { $0 + ($1.calories) }
            let mealProtein = meal.foodItems?.reduce(0) { $0 + ($1.protein) }
            let mealCarbs = meal.foodItems?.reduce(0) { $0 + ($1.carbs) }
            let mealFat = meal.foodItems?.reduce(0) { $0 + ($1.fat) }
            
            dayActivity.calories += mealCalories ?? 0
            dayActivity.protein += mealProtein ?? 0
            dayActivity.carbs += mealCarbs ?? 0
            dayActivity.fat += mealFat ?? 0
            
            await bgContext.perform {
                
                do {
                    try self.bgContext.save()
                }
                catch {
                    print("Error caused during saving DailyActivity", error.localizedDescription)
                }
            }
            
            let dailyActivityModel = DailyActivityModel(dailyActivity: dayActivity)
            
            dailyActiviyManager.publishDailyActivity(dailyActivityModel)
            
        }
        
    }
    
    func deleteMeal(_ deleteData: MealModel) async {
        
    }
    
}
