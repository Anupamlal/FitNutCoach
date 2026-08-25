//
//  WorkoutsView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct WorkoutsView: View {

    @StateObject private var viewModel = WorkoutsViewModel()
    @StateObject private var workoutRouter = Router<WorkoutRouter>()
    @EnvironmentObject private var rootTabViewModel: RootTabViewModel

    var body: some View {
        NavigationStack(path: $workoutRouter.navigationPath) {
            rootContent
                .navigationDestination(for: WorkoutRouter.self) { route in
                    workoutRouter.destination(for: route, onSetupComplete: handleSetupComplete)
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
        }
        .toolbarVisibility(viewModel.shouldHideTabBar ? .hidden : .visible, for: .tabBar)
        .animation(.easeInOut(duration: 0.3), value: viewModel.shouldHideTabBar)
        .onAppear {
            viewModel.refreshSetupState()
        }
    }

    @ViewBuilder
    private var rootContent: some View {
        Group {
            switch viewModel.currentScreen {
            case .intro:
                WorkoutIntroView(
                    onLetsBuild: { workoutRouter.navigate(to: .routineSetup) },
                    onMaybeLater: rootTabViewModel.dismissWorkoutIntro
                )
            case .home:
                WorkoutHomeView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func handleSetupComplete() {
        viewModel.completeSetup()
        workoutRouter.navigateToRoot()
    }
}

#Preview {
    WorkoutsView()
        .environmentObject(RootTabViewModel())
}
