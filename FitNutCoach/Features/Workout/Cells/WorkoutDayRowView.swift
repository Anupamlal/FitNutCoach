//
//  WorkoutDayRowView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/08/26.
//

import SwiftUI

struct WorkoutDayRowView: View {

    let day: WorkoutRoutineDay
    let orderNumber: Int
    let isSelected: Bool
    let onAdd: () -> Void

    var body: some View {
        Card(shadowEnable: true, cornerRadius: 16) {
            HStack(spacing: AppSpacing.m) {
                WorkoutDayIconView(day: day)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("\(orderNumber). \(day.title)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)

                    Text(day.subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                Button(action: onAdd) {
                    Group {
                        if isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                        } else {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.textSecondary.opacity(0.4) : Color.primaryAccent)
                    )
                }
                .disabled(isSelected)
            }
        }
    }
}

#Preview {
    WorkoutDayRowView(day: .chest, orderNumber: 1, isSelected: false, onAdd: {})
        .padding()
}
