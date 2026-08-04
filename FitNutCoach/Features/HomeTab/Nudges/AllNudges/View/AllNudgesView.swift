//
//  AllNudgesView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/10/25.
//

import SwiftUI

struct AllNudgesView: View {
    
    @StateObject private var viewModel: AllNudgesViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject private var rootTabViewModel: RootTabViewModel
    @EnvironmentObject var homeNavRouter: Router<HomeRouter>
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    init(nudgeManager: NudgeManager) {
        _viewModel = StateObject(wrappedValue: AllNudgesViewModel(nudgeManager: nudgeManager))
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    headerCard
                    
                    if !viewModel.priorityNudges.isEmpty {
                        sectionHeader(AppTexts.nudgePrioritySectionText)
                        ForEach(viewModel.priorityNudges) { nudge in
                            nudgeCell(nudge)
                        }
                    }
                    
                    if !viewModel.groupedNudges.isEmpty {
                        sectionHeader(AppTexts.nudgeAllSectionText)
                        ForEach(viewModel.groupedNudges, id: \.category) { group in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(group.category.displayName())
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                    .padding(.horizontal, 4)
                                
                                ForEach(group.nudges) { nudge in
                                    if !viewModel.priorityNudges.contains(where: { $0.id == nudge.id }) {
                                        nudgeCell(nudge)
                                    }
                                }
                            }
                        }
                    }
                    
                    if !viewModel.completedNudges.isEmpty {
                        sectionHeader(AppTexts.nudgeCompletedSectionText)
                        ForEach(viewModel.completedNudges) { nudge in
                            NudgeDetailCellView(
                                nudge: nudge,
                                showCompletedTimestamp: true,
                                onMarkCompleted: {},
                                onDismiss: {},
                                onAction: {}
                            )
                        }
                    }
                    
                    if viewModel.pendingCount == 0 && viewModel.completedNudges.isEmpty {
                        Text(AppTexts.nudgeNoActiveText)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
        }
        .withCustomBackButton(withTitle: AppTexts.nudgesTitleText)
        .onAppear {
            viewModel.updateHealthContext(
                profile: homeViewModel.profileModel,
                activity: homeViewModel.dailyActivityModel
            )
        }
        .onChange(of: homeViewModel.dailyActivityModel.calories) { _, _ in
            viewModel.updateHealthContext(
                profile: homeViewModel.profileModel,
                activity: homeViewModel.dailyActivityModel
            )
        }
    }
    
    private var headerCard: some View {
        Card(backgroundColor: .white) {
            HStack(spacing: AppSpacing.s) {
                Text("💡")
                    .font(.system(size: 35, weight: .bold))
                
                VStack(alignment: .leading, spacing: AppSpacing.s) {
                    Text(String(format: AppTexts.nudgeSmartNudgesTodayText, "\(viewModel.totalCount)"))
                        .foregroundStyle(Color.textPrimary)
                        .font(.system(size: 18, weight: .semibold))
                    
                    Text(String(
                        format: AppTexts.nudgeCompletedPendingText,
                        "\(viewModel.completedCount)",
                        "\(viewModel.pendingCount)"
                    ))
                        .foregroundStyle(Color.textSecondary)
                        .font(.system(size: 16, weight: .regular))
                    
                    Divider()
                    
                    Text(AppTexts.nudgeHealthScoreText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.textSecondary)
                    
                    Text("\(viewModel.healthScore)%")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.primaryAccent)
                    
                    Text(viewModel.motivationalMessage)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                }
                
                Spacer()
            }
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(Color.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
    }
    
    private func nudgeCell(_ nudge: NudgeModel) -> some View {
        NudgeDetailCellView(
            nudge: nudge,
            onMarkCompleted: { viewModel.markCompleted(nudge) },
            onDismiss: { viewModel.dismiss(nudge) },
            onAction: {
                viewModel.handleAction(
                    for: nudge,
                    homeNavRouter: homeNavRouter,
                    rootTabViewModel: rootTabViewModel,
                    onOpenWater: { homeViewModel.openWaterIntakeView = true }
                )
            }
        )
    }
}

#Preview {
    NavigationStack {
        AllNudgesView(nudgeManager: NudgeManager(container: PersistenceController.shared.container))
    }
}
