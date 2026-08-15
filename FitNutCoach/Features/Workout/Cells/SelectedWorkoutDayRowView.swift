//
//  SelectedWorkoutDayRowView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/08/26.
//

import SwiftUI

struct SelectedWorkoutDayRowView: View {

    let orderIndex: Int
    let day: WorkoutRoutineDay
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Text("\(orderIndex).")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Color.primaryAccent)
                .frame(width: 24, alignment: .leading)

            WorkoutDayIconView(day: day, size: 36)

            Text(day.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.textSecondary)
                    .frame(width: 24, height: 24)
                    .background(Color(hex: 0xF3F4F6))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, AppSpacing.m)
        .padding(.vertical, AppSpacing.s)
        .background(Color(hex: 0xF8F9FB))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SelectedWorkoutDayRowView(orderIndex: 1, day: .chest, onRemove: {})
        .padding()
}
