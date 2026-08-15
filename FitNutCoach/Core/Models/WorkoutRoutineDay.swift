//
//  WorkoutRoutineDay.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/08/26.
//

import SwiftUI

enum WorkoutRoutineDay: String, CaseIterable, Identifiable {
    case chest
    case legs
    case shoulders
    case back
    case arms
    case fullBody
    case cardio

    var id: String { rawValue }

    var title: String {
        switch self {
        case .chest: return "Chest Day"
        case .legs: return "Leg Day"
        case .shoulders: return "Shoulder Day"
        case .back: return "Back Day"
        case .arms: return "Arms Day"
        case .fullBody: return "Full Body"
        case .cardio: return "Cardio"
        }
    }

    var subtitle: String {
        switch self {
        case .chest: return "Build and strengthen your chest"
        case .legs: return "Power up your lower body"
        case .shoulders: return "Sculpt strong shoulders"
        case .back: return "Develop a strong back"
        case .arms: return "Tone your biceps & triceps"
        case .fullBody: return "Hit every muscle group"
        case .cardio: return "Boost endurance & burn calories"
        }
    }

    var iconName: String {
        switch self {
        case .chest: return "figure.arms.open"
        case .legs: return "figure.walk"
        case .shoulders: return "figure.boxing"
        case .back: return "figure.cooldown"
        case .arms: return "figure.strengthtraining.traditional"
        case .fullBody: return "figure.mixed.cardio"
        case .cardio: return "figure.run"
        }
    }

    var iconBackgroundColor: Color {
        switch self {
        case .chest: return Color(hex: 0xFFE4E6)
        case .legs: return Color(hex: 0xDCFCE7)
        case .shoulders: return Color(hex: 0xFFEDD5)
        case .back: return Color(hex: 0xDBEAFE)
        case .arms: return Color(hex: 0xEDE9FE)
        case .fullBody: return Color(hex: 0xCCFBF1)
        case .cardio: return Color(hex: 0xFEF3C7)
        }
    }

    var iconForegroundColor: Color {
        switch self {
        case .chest: return Color(hex: 0xEF4444)
        case .legs: return Color(hex: 0x22C55E)
        case .shoulders: return Color(hex: 0xF97316)
        case .back: return Color(hex: 0x3B82F6)
        case .arms: return Color(hex: 0x8B5CF6)
        case .fullBody: return Color(hex: 0x14B8A6)
        case .cardio: return Color(hex: 0xD97706)
        }
    }
}
