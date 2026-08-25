//
//  RootTabViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 01/09/25.
//

import SwiftUI

class RootTabViewModel: ObservableObject {

    @Published var currentTab: RootTabSection = .home
    @Published private(set) var previousTab: RootTabSection = .home

    func capturePreviousTabIfNeeded(from oldTab: RootTabSection, to newTab: RootTabSection) {
        guard newTab == .workouts, oldTab != .workouts else { return }
        previousTab = oldTab
    }

    func dismissWorkoutIntro() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentTab = previousTab
        }
    }
}
