//
//  WorkoutsViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/08/26.
//

import SwiftUI
import Combine

class WorkoutsViewModel: ObservableObject {

    @Published var selectedWorkoutDays: [WorkoutRoutineDay] = []

    let availableWorkoutDays = WorkoutRoutineDay.allCases
    let maxWorkoutDays = WorkoutRoutineDay.allCases.count

    var selectedCountText: String {
        "\(selectedWorkoutDays.count) / \(maxWorkoutDays) selected"
    }

    func isSelected(_ day: WorkoutRoutineDay) -> Bool {
        selectedWorkoutDays.contains(day)
    }

    func orderNumber(for day: WorkoutRoutineDay) -> Int {
        (availableWorkoutDays.firstIndex(of: day) ?? 0) + 1
    }

    func addWorkoutDay(_ day: WorkoutRoutineDay) {
        guard !selectedWorkoutDays.contains(day) else { return }
        selectedWorkoutDays.append(day)
    }

    func removeWorkoutDay(_ day: WorkoutRoutineDay) {
        selectedWorkoutDays.removeAll { $0 == day }
    }

    func continueTapped() {
        // TODO: Navigate to next step
    }
}
