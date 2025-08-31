//
//  DailyActivityModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import UIKit
import CoreData

struct DailyActivityModel: Codable {
    
    let id: UUID?
    let activeEnergy: Double
    let calories: Double
    let carbs: Double
    let date: Date?
    let exerciseMinutes: Int16
    let fat: Double
    let protein: Double
    let sleepMinutes: Int16
    let steps: Int32
    let updatedAt: Date?
    let waterLiters: Double
    var meals: [MealModel]?
    var workouts: [WorkoutModel]?
    
    init(id: UUID?, activeEnergy: Double, calories: Double, carbs: Double, date: Date?, exerciseMinutes: Int16, fat: Double, protein: Double, sleepMinutes: Int16, steps: Int32, updatedAt: Date?, waterLiters: Double, meals: [MealModel]?, workouts: [WorkoutModel]?) {
        self.id = id
        self.activeEnergy = activeEnergy
        self.calories = calories
        self.carbs = carbs
        self.date = date
        self.exerciseMinutes = exerciseMinutes
        self.fat = fat
        self.protein = protein
        self.sleepMinutes = sleepMinutes
        self.steps = steps
        self.updatedAt = updatedAt
        self.waterLiters = waterLiters
        self.meals = meals
        self.workouts = workouts
    }
    
    init() {
        let start = Calendar.current.startOfDay(for: Date())
        
        self.init(id: UUID(), activeEnergy: 0, calories: 0, carbs: 0, date: start, exerciseMinutes: 0, fat: 0, protein: 0, sleepMinutes: 0, steps: 0, updatedAt: nil, waterLiters: 0, meals: nil, workouts: nil)
    }
    
    init(dailyActivity: DailyActivity) {
        self.id = dailyActivity.id
        self.activeEnergy = dailyActivity.activeEnergy
        self.calories = dailyActivity.calories
        self.carbs = dailyActivity.carbs
        self.date = dailyActivity.date
        self.exerciseMinutes = dailyActivity.exerciseMinutes
        self.fat = dailyActivity.fat
        self.protein = dailyActivity.protein
        self.sleepMinutes = dailyActivity.sleepMinutes
        self.steps = dailyActivity.steps
        self.updatedAt = dailyActivity.updatedAt
        self.waterLiters = dailyActivity.waterLiters
        
        if let meals = dailyActivity.meals as? Set<Meal> {
            for meal in meals {
                if self.meals == nil {
                    self.meals = []
                }
                self.meals?.append(MealModel(meal: meal))
            }
        }else {
            self.meals = nil
        }
        
        if let workouts = dailyActivity.workouts as? Set<Workout> {
            
            for workout in workouts {
                if self.workouts == nil {
                    self.workouts = []
                }
                self.workouts?.append(WorkoutModel(workout: workout))
            }
            
        }else {
            self.workouts = nil
        }
        
    }
    
    func fillDailyActivity(dailyActivity: DailyActivity, context: NSManagedObjectContext) {
        dailyActivity.id = self.id
        dailyActivity.activeEnergy = self.activeEnergy
        dailyActivity.calories = self.calories
        dailyActivity.carbs = self.carbs
        dailyActivity.date = self.date
        dailyActivity.exerciseMinutes = self.exerciseMinutes
        dailyActivity.fat = self.fat
        dailyActivity.protein = self.protein
        dailyActivity.sleepMinutes = self.sleepMinutes
        dailyActivity.steps = self.steps
        dailyActivity.updatedAt = self.updatedAt
        dailyActivity.waterLiters = self.waterLiters
        
        if let meals = self.meals {
            var allMeal = Set<Meal>()
            
            for meal in meals {
                let mealCD = Meal(context: context)
                meal.fillMeal(meal: mealCD, context: context)
                
                allMeal.insert(mealCD)
            }
            dailyActivity.meals = allMeal as NSSet
        }
        
        if let workouts = self.workouts {
            var allWorkout = Set<Workout>()
            
            for workout in workouts {
                let workoutCD = Workout(context: context)
                workout.fillWorkout(workout: workoutCD, context: context)
                
                allWorkout.insert(workoutCD)
            }
            
            dailyActivity.workouts = allWorkout as NSSet
        }
    }
}
