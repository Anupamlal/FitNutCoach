//
//  DailyActivityManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI
import Combine
import CoreData

class DailyActivityManager: ObservableObject {
        
    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    private let dailyActivitySubject = CurrentValueSubject<DailyActivityModel, Never>(DailyActivityModel())
    
    var managerPublisher: AnyPublisher<DailyActivityModel, Never> {
        dailyActivitySubject.eraseToAnyPublisher()
    }
    
    init(container: NSPersistentContainer) {
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func addNewOrUpdateData(_ newData: DailyActivityModel) async -> Bool {
        let dailyActivity = DailyActivity(context: self.bgContext)
        newData.fillDailyActivity(dailyActivity: dailyActivity, context: self.bgContext)
        
        await bgContext.perform {
            
            do {
                try self.bgContext.save()
            }
            catch {
                print("Error caused during saving DailyActivity", error.localizedDescription)
            }
        }
        
        self.publishDailyActivity(newData)
        return true
    }
    
    func deleteData(_ deleteData: DailyActivityModel) async -> Bool {
        return true
    }
    
    func loadData(date: Date, viewContextObj: NSManagedObjectContext? = nil) async -> DailyActivity? {
        let fetchRequest = DailyActivity.fetchRequest()
        let start = date.getStartOfDate()
        
        fetchRequest.predicate = NSPredicate(format: "date == %@", start as NSDate)
        fetchRequest.fetchLimit = 1
        
        var currentViewContext = viewContextObj
        if currentViewContext == nil {
            currentViewContext = self.viewContext
        }
        
        if let dailyActivity = try? currentViewContext?.fetch(fetchRequest).first {
            return dailyActivity
        }
        
        return nil
    }
    
    func loadTodayData() async -> Bool{
        if let dailyActivity = await self.loadData(date: Date()) {
            let dailyActivityModel = DailyActivityModel(dailyActivity: dailyActivity)
            self.publishDailyActivity(dailyActivityModel)
            
        }else {
            let dailyActivityModel = DailyActivityModel()
            _ = await self.addNewOrUpdateData(dailyActivityModel)
        }
        
        return true
        
    }
    
    func addWatersIntake(_ amount: Double) async {
        guard let dailyActivity = await self.loadData(date: Date()) else {
            return
        }
        
        dailyActivity.waterLiters += amount
        dailyActivity.updatedAt = Date()
        _ = await self.addNewOrUpdateData(DailyActivityModel(dailyActivity: dailyActivity))
    }
    
    func addSteps(_ amount: Int) async {
        guard let dailyActivity = await self.loadData(date: Date()) else {
            return
        }
        
        dailyActivity.steps += Int32(amount)
        dailyActivity.updatedAt = Date()
        _ = await self.addNewOrUpdateData(DailyActivityModel(dailyActivity: dailyActivity))
    }
    
    func publishDailyActivity(_ dailyActivityModel: DailyActivityModel) {
        self.dailyActivitySubject.send(dailyActivityModel)
    }
    
    func addMeal(_ meal: MealModel) async -> Bool {
        
        if let date = meal.date, let dayActivity = await self.loadData(date: date, viewContextObj: self.bgContext) {
            
            let mealCD = Meal(context: self.bgContext)
            
            meal.fillMeal(meal: mealCD, context: self.bgContext)
            mealCD.dailyActivity = dayActivity
            
            
            let totalCalories = meal.foodItems?.reduce(0, {$0+$1.calories})
            let totalProtien = meal.foodItems?.reduce(0, {$0+$1.protein})
            let totalCarbs = meal.foodItems?.reduce(0, {$0+$1.carbs})
            let totalFat = meal.foodItems?.reduce(0, {$0+$1.fat})
            
            dayActivity.calories = totalCalories ?? 0
            dayActivity.protein = totalProtien ?? 0
            dayActivity.carbs = totalCarbs ?? 0
            dayActivity.fat = totalFat ?? 0
            dayActivity.updatedAt = Date()
            
            await bgContext.perform {
                
                do {
                    try self.bgContext.save()
                }
                catch {
                    print("Error caused during saving DailyActivity", error.localizedDescription)
                }
            }
            
            let dailyActivityModel = DailyActivityModel(dailyActivity: dayActivity)
            
            self.publishDailyActivity(dailyActivityModel)
            
            return true
            
        }
        
        return false
    }

}
