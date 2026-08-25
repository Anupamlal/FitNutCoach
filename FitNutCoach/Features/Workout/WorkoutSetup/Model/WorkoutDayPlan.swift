//
//  WorkoutDayPlan.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 25/08/26.
//

import Foundation

enum WorkoutWeekday: String, CaseIterable, Identifiable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var id: String { rawValue }

    var shortLabel: String {
        switch self {
        case .monday: return "MON"
        case .tuesday: return "TUE"
        case .wednesday: return "WED"
        case .thursday: return "THU"
        case .friday: return "FRI"
        case .saturday: return "SAT"
        case .sunday: return "SUN"
        }
    }
}

enum WorkoutMuscleGroup: String, CaseIterable, Identifiable {
    case chest
    case back
    case shoulders
    case arms
    case legs
    case core
    case cardio

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .chest: return "Chest"
        case .back: return "Back"
        case .shoulders: return "Shoulders"
        case .arms: return "Arms"
        case .legs: return "Legs"
        case .core: return "Core"
        case .cardio: return "Cardio"
        }
    }
}

struct WorkoutDayPlan: Identifiable {
    let weekday: WorkoutWeekday
    var muscleGroups: [WorkoutMuscleGroup] = []
    var isRestDay: Bool = false

    var id: String { weekday.id }

    var statusText: String {
        if isRestDay {
            return AppTexts.workoutSetupRestDayText
        }
        if muscleGroups.isEmpty {
            return AppTexts.workoutSetupTapToAddMusclesText
        }
        return muscleGroups.map(\.displayName).joined(separator: ", ")
    }

    var isConfigured: Bool {
        isRestDay || !muscleGroups.isEmpty
    }
}
