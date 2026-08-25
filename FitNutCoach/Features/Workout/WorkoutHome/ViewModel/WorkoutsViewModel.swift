//
//  WorkoutsViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/08/26.
//

import SwiftUI
import Combine

enum WorkoutScreen {
    case intro
    case home
}

class WorkoutsViewModel: ObservableObject {

    @Published private(set) var currentScreen: WorkoutScreen
    @Published private(set) var isWorkoutSetupDone: Bool

    init() {
        let setupDone = UserDefaultManager.isWorkoutSetupDone()
        isWorkoutSetupDone = setupDone
        currentScreen = setupDone ? .home : .intro
    }

    var shouldHideTabBar: Bool {
        !isWorkoutSetupDone && currentScreen == .intro
    }

    func refreshSetupState() {
        let setupDone = UserDefaultManager.isWorkoutSetupDone()
        isWorkoutSetupDone = setupDone
        if setupDone {
            currentScreen = .home
        } else if currentScreen == .home {
            currentScreen = .intro
        }
    }

    func completeSetup() {
        UserDefaultManager.saveWorkoutSetupDone(true)
        isWorkoutSetupDone = true
        currentScreen = .home
    }
}
