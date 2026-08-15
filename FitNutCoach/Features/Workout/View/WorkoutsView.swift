//
//  WorkoutsView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct WorkoutsView: View {

    @StateObject private var viewModel = WorkoutsViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        WorkoutRoutineHeaderView()

                        WorkoutOrderCardView(
                            selectedWorkoutDays: viewModel.selectedWorkoutDays,
                            selectedCountText: viewModel.selectedCountText,
                            onRemove: viewModel.removeWorkoutDay
                        )

                        WorkoutDayListSectionView(
                            availableDays: viewModel.availableWorkoutDays,
                            isSelected: viewModel.isSelected,
                            orderNumber: viewModel.orderNumber,
                            onAdd: viewModel.addWorkoutDay
                        )
                    }
                    .padding(.horizontal, AppSpacing.l)
                    .padding(.top, AppSpacing.m)
                    .padding(.bottom, 100)
                }

                continueButton
                    .padding(.horizontal, AppSpacing.l)
                    .padding(.bottom, AppSpacing.l)
            }
            .navigationBarHidden(true)
        }
    }

    private var continueButton: some View {
        Button(action: viewModel.continueTapped) {
            HStack(spacing: AppSpacing.s) {
                Text("Continue")
                    .font(.system(size: 16, weight: .semibold))

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.primaryAccent)
            )
            .shadow(color: Color.primaryAccent.opacity(0.3), radius: 8, y: 4)
        }
    }
}

#Preview {
    WorkoutsView()
}
