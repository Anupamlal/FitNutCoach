//
//  WorkoutRoutineSetupView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/08/26.
//

import SwiftUI

struct WorkoutRoutineSetupView: View {

    @StateObject private var viewModel = WorkoutRoutineSetupViewModel()
    let onComplete: () -> Void
    let onDayTap: (WorkoutWeekday) -> Void

    init(
        onComplete: @escaping () -> Void,
        onDayTap: @escaping (WorkoutWeekday) -> Void = { _ in }
    ) {
        self.onComplete = onComplete
        self.onDayTap = onDayTap
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection

                    Spacer()
                        .frame(height: AppSpacing.l)

                    weekPlanSection

                    Spacer()
                        .frame(height: AppSpacing.m)

                    TipCell()
                }
                .padding(.horizontal, AppSpacing.l)
                .padding(.top, AppSpacing.m)
                .padding(.bottom, 100)
            }

            FNButton(
                buttonTitle: AppTexts.continueText,
                backgroundEnable: true,
                isEnabled: viewModel.canContinue,
                cornerRadius: 14,
                buttonHeight: 52,
                buttonAction: onComplete
            )
            .padding(.horizontal, AppSpacing.l)
            .padding(.bottom, AppSpacing.l)
        }
        .navigationBarBackButtonHidden(false)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(AppTexts.workoutSetupTitleText)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Text(AppTexts.workoutSetupSubtitleText)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var weekPlanSection: some View {
        VStack(spacing: AppSpacing.xs) {
            ForEach(viewModel.weekPlan) { dayPlan in
                WorkoutSetupCell(
                    dayLabel: dayPlan.weekday.shortLabel,
                    statusText: dayPlan.statusText,
                    isConfigured: dayPlan.isConfigured,
                    onTap: { onDayTap(dayPlan.weekday) }
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutRoutineSetupView(onComplete: {})
    }
}
