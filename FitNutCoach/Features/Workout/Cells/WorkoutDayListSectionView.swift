//
//  WorkoutDayListSectionView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/08/26.
//

import SwiftUI

struct WorkoutDayListSectionView: View {

    let availableDays: [WorkoutRoutineDay]
    let isSelected: (WorkoutRoutineDay) -> Bool
    let orderNumber: (WorkoutRoutineDay) -> Int
    let onAdd: (WorkoutRoutineDay) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            Text("ADD WORKOUT DAY")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .tracking(0.5)

            VStack(spacing: AppSpacing.m) {
                ForEach(availableDays) { day in
                    WorkoutDayRowView(
                        day: day,
                        orderNumber: orderNumber(day),
                        isSelected: isSelected(day),
                        onAdd: { onAdd(day) }
                    )
                }
            }
        }
    }
}

#Preview {
    WorkoutDayListSectionView(
        availableDays: WorkoutRoutineDay.allCases,
        isSelected: { _ in false },
        orderNumber: { day in (WorkoutRoutineDay.allCases.firstIndex(of: day) ?? 0) + 1 },
        onAdd: { _ in }
    )
    .padding()
}
