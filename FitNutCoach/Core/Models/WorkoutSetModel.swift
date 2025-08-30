//
//  WorkoutSetModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI

struct WorkoutSetModel: Codable {
    let exercise: String?
    let id: UUID?
    let reps: Int16
    let rpe: Int16
    let setIndex: Int16
    let weight: Double
    
    init(exercise: String?, id: UUID?, reps: Int16, rpe: Int16, setIndex: Int16, weight: Double) {
        self.exercise = exercise
        self.id = id
        self.reps = reps
        self.rpe = rpe
        self.setIndex = setIndex
        self.weight = weight
    }
    
    init() {
        self.init(exercise: nil, id: UUID(), reps: 0, rpe: 0, setIndex: 0, weight: 0)
    }
    
    init(workoutSet: WorkoutSet) {
        self.exercise = workoutSet.exercise
        self.id = workoutSet.id
        self.reps = workoutSet.reps
        self.rpe = workoutSet.rpe
        self.setIndex = workoutSet.setIndex
        self.weight = workoutSet.weight
    }
    
    func fillWorkoutSet(workoutSet: WorkoutSet) {
        workoutSet.exercise = self.exercise
        workoutSet.id = self.id
        workoutSet.reps = self.reps
        workoutSet.rpe = self.rpe
        workoutSet.setIndex = self.setIndex
        workoutSet.weight = self.weight
    }
}
