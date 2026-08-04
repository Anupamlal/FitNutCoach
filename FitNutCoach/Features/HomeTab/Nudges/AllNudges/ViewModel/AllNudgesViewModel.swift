//
//  AllNudgesViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 04/08/26.
//

import SwiftUI
import Combine

final class AllNudgesViewModel: ObservableObject {
    
    @Published var healthScore: Int = 0
    @Published var motivationalMessage: String = ""
    @Published var priorityNudges: [NudgeModel] = []
    @Published var groupedNudges: [(category: NudgeCategory, nudges: [NudgeModel])] = []
    @Published var completedNudges: [NudgeModel] = []
    @Published var totalCount: Int = 0
    @Published var completedCount: Int = 0
    @Published var pendingCount: Int = 0
    
    private let nudgeManager: NudgeManager
    private var cancellables = Set<AnyCancellable>()
    
    init(nudgeManager: NudgeManager) {
        self.nudgeManager = nudgeManager
        
        nudgeManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nudges in
                self?.refresh(from: nudges)
            }
            .store(in: &cancellables)
    }
    
    func refresh(from nudges: [NudgeModel]) {
        priorityNudges = nudges.filter { $0.isVisible && $0.priority == .high }
        completedNudges = nudges.filter { $0.status == .completed }
        
        let activeByCategory = Dictionary(grouping: nudges.filter(\.isVisible), by: \.category)
        groupedNudges = NudgeCategory.allCases.compactMap { category in
            guard let categoryNudges = activeByCategory[category], !categoryNudges.isEmpty else { return nil }
            return (category, categoryNudges)
        }
        
        totalCount = nudges.filter { $0.status == .active || $0.status == .completed }.count
        completedCount = completedNudges.count
        pendingCount = nudges.filter(\.isVisible).count
    }
    
    func updateHealthContext(profile: ProfileModel, activity: DailyActivityModel) {
        healthScore = NudgeModel.calculateHealthScore(profile: profile, activity: activity)
        motivationalMessage = NudgeModel.motivationalMessage(for: healthScore)
    }
    
    func markCompleted(_ nudge: NudgeModel) {
        Task { await nudgeManager.markCompleted(nudge: nudge) }
    }
    
    func dismiss(_ nudge: NudgeModel) {
        Task { await nudgeManager.markDismissed(nudge: nudge) }
    }
    
    func handleAction(
        for nudge: NudgeModel,
        homeNavRouter: Router<HomeRouter>,
        rootTabViewModel: RootTabViewModel,
        onOpenWater: () -> Void
    ) {
        switch nudge.actionType {
        case .openWaterTracker:
            homeNavRouter.navigateToRoot()
            onOpenWater()
        case .openFoodLogger:
            homeNavRouter.navigate(to: .logMeal)
            homeNavRouter.navigate(to: .addFoodItem(selectedMealType: .suggestedForCurrentTime()))
        case .openMealLog:
            let mealType = MealType(rawValue: nudge.actionValue ?? "") ?? .suggestedForCurrentTime()
            homeNavRouter.navigate(to: .logMeal)
            homeNavRouter.navigate(to: .addFoodItem(selectedMealType: mealType))
        case .openActivity:
            homeNavRouter.navigateToRoot()
            rootTabViewModel.currentTab = .trends
        case .openWeight:
            homeNavRouter.navigateToRoot()
            rootTabViewModel.currentTab = .profile
        case .openWorkout:
            homeNavRouter.navigateToRoot()
            rootTabViewModel.currentTab = .workouts
        case .viewDetails, .none:
            break
        }
    }
}
