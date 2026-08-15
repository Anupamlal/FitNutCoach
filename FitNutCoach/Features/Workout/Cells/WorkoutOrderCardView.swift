//
//  WorkoutOrderCardView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/08/26.
//

import SwiftUI

struct WorkoutOrderCardView: View {

    let selectedWorkoutDays: [WorkoutRoutineDay]
    let selectedCountText: String
    let onRemove: (WorkoutRoutineDay) -> Void

    var body: some View {
        Card(shadowEnable: true, cornerRadius: 20) {
            VStack(alignment: .leading, spacing: AppSpacing.m) {
                HStack(alignment: .center) {
                    HStack(spacing: AppSpacing.xs) {
                        Text("YOUR WORKOUT ORDER")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.textSecondary)
                            .tracking(0.5)

                        Image(systemName: "info.circle")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary.opacity(0.6))
                    }

                    Spacer()

                    Text(selectedCountText)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.primaryAccent)
                }

                if selectedWorkoutDays.isEmpty {
                    emptyStateView
                } else {
                    selectedDaysList
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.m) {
            ZStack {
                Image(systemName: "checklist")
                    .font(.system(size: 36))
                    .foregroundStyle(Color.textSecondary.opacity(0.35))

                Circle()
                    .fill(Color.primaryAccent)
                    .frame(width: 22, height: 22)
                    .overlay {
                        Image(systemName: "plus")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .offset(x: 22, y: 14)
            }
            .padding(.top, AppSpacing.s)

            Text("Your workout order is empty")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.textPrimary)

            Text("Tap a workout below to add it to your routine")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xl)
        .padding(.horizontal, AppSpacing.m)
        .background(dashedBorder)
    }

    private var selectedDaysList: some View {
        VStack(spacing: AppSpacing.s) {
            ForEach(Array(selectedWorkoutDays.enumerated()), id: \.element.id) { index, day in
                SelectedWorkoutDayRowView(
                    orderIndex: index + 1,
                    day: day,
                    onRemove: { onRemove(day) }
                )
            }
        }
        .padding(AppSpacing.m)
        .background(dashedBorder)
    }

    private var dashedBorder: some View {
        RoundedRectangle(cornerRadius: 16)
            .strokeBorder(
                style: StrokeStyle(lineWidth: 1.5, dash: [8, 6])
            )
            .foregroundStyle(Color.primaryAccent.opacity(0.35))
    }
}

#Preview {
    WorkoutOrderCardView(
        selectedWorkoutDays: [.chest, .legs],
        selectedCountText: "2 / 7 selected",
        onRemove: { _ in }
    )
    .padding()
}
