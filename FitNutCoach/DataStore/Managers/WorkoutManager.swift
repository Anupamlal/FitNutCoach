//
//  WorkoutManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 31/08/25.
//

import SwiftUI
import Combine
import CoreData

class WorkoutManager: ObservableObject {
    
    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    
    private let dailyActiviyManager: DailyActivityManager
    
    init(container: NSPersistentContainer, dailyActiviyManager: DailyActivityManager) {
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.dailyActiviyManager = dailyActiviyManager
    }
    
    func addWorkout(workout: WorkoutModel) async {
        if let date = workout.date, let dayActivity = await dailyActiviyManager.loadData(date: date) {
            
            let workoutCD = Workout(context: self.bgContext)
            
            workout.fillWorkout(workout: workoutCD, context: self.bgContext)
            workoutCD.dailyActivity = dayActivity
            
            dayActivity.exerciseMinutes += workoutCD.durationMin
            dayActivity.activeEnergy += workoutCD.kcal
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
            
            dailyActiviyManager.publishDailyActivity(dailyActivityModel)
            
        }
        
    }
    
    func editWorkout(_ editData: WorkoutModel) async {
        
    }
    
}
