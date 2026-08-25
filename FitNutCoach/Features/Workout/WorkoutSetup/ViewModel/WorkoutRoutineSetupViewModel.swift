//
//  WorkoutRoutineSetupViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 25/08/26.
//

import SwiftUI
import Combine

class WorkoutRoutineSetupViewModel: ObservableObject {

    @Published var weekPlan: [WorkoutDayPlan]

    init() {
        weekPlan = WorkoutWeekday.allCases.map { WorkoutDayPlan(weekday: $0) }
    }

    var canContinue: Bool {
        weekPlan.contains { $0.isConfigured }
    }

    func dayPlan(for weekday: WorkoutWeekday) -> WorkoutDayPlan? {
        weekPlan.first { $0.weekday == weekday }
    }

    func updateDay(_ weekday: WorkoutWeekday, muscleGroups: [WorkoutMuscleGroup], isRestDay: Bool) {
        guard let index = weekPlan.firstIndex(where: { $0.weekday == weekday }) else { return }
        weekPlan[index].muscleGroups = muscleGroups
        weekPlan[index].isRestDay = isRestDay
    }
}
