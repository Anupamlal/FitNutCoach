//
//  WorkoutModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI
import CoreData

struct WorkoutModel: Codable {
    let id: UUID?
    let avgHR: Int16
    let date: Date?
    let distanceKm: Double
    let durationMin: Double
    let endDate: Date?
    let kcal: Double
    let maxHR: Int16
    let notes: String?
    let rpe: Int16
    let source: String?
    let type: String?
    var workoutSets: [WorkoutSetModel]?
    
    init(id: UUID?, avgHR: Int16, date: Date?, distanceKm: Double, durationMin: Double, endDate: Date?, kcal: Double, maxHR: Int16, notes: String?, rpe: Int16, source: String?, type: String?, workoutSets: [WorkoutSetModel]?) {
        self.id = id
        self.avgHR = avgHR
        self.date = date
        self.distanceKm = distanceKm
        self.durationMin = durationMin
        self.endDate = endDate
        self.kcal = kcal
        self.maxHR = maxHR
        self.notes = notes
        self.rpe = rpe
        self.source = source
        self.type = type
        self.workoutSets = workoutSets
    }
    
    init() {
        self.init(id: UUID(), avgHR: 0, date: nil, distanceKm: 0, durationMin: 0, endDate: nil, kcal: 0, maxHR: 0, notes: nil, rpe: 0, source: nil, type: nil, workoutSets: nil)
    }
    
    init(workout: Workout) {
        self.id = workout.id
        self.avgHR = workout.avgHR
        self.date = workout.date
        self.distanceKm = workout.distanceKm
        self.durationMin = workout.durationMin
        self.endDate = workout.endDate
        self.kcal = workout.kcal
        self.maxHR = workout.maxHR
        self.notes = workout.notes
        self.rpe = workout.rpe
        self.source = workout.source
        self.type = workout.type
        
        if let workoutSets = workout.sets as? Set<WorkoutSet> {
            for workoutSet in workoutSets {
                
                if self.workoutSets == nil {
                    self.workoutSets = []
                }
                
                self.workoutSets?.append(WorkoutSetModel(workoutSet: workoutSet))
            }
        }else {
            self.workoutSets = nil
        }
    }
    
    func fillWorkout(workout: Workout, context: NSManagedObjectContext) {
        workout.id = self.id
        workout.avgHR = self.avgHR
        workout.date = self.date
        workout.distanceKm = self.distanceKm
        workout.durationMin = self.durationMin
        workout.endDate = self.endDate
        workout.kcal = self.kcal
        workout.maxHR = self.maxHR
        workout.notes = self.notes
        workout.rpe = self.rpe
        workout.source = self.source
        workout.type = self.type
        
        if let workoutSets = self.workoutSets {
            var allWorkoutCD = Set<WorkoutSet>()
            for workoutSet in workoutSets {
                
                let workoutSetCD = WorkoutSet(context: context)
                workoutSet.fillWorkoutSet(workoutSet: workoutSetCD)
                
                allWorkoutCD.insert(workoutSetCD)
            }
            
            workout.sets = allWorkoutCD as NSSet
        }
        
    }
}
