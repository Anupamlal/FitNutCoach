//
//  Router+Workout.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/08/26.
//

import SwiftUI

extension Router {

    @ViewBuilder
    func destination(
        for workoutRouter: WorkoutRouter,
        onSetupComplete: @escaping () -> Void
    ) -> some View {
        switch workoutRouter {
        case .routineSetup:
            WorkoutRoutineSetupView(onComplete: onSetupComplete)
        }
    }
}
