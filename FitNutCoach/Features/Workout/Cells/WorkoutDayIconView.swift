//
//  WorkoutDayIconView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/08/26.
//

import SwiftUI

struct WorkoutDayIconView: View {

    let day: WorkoutRoutineDay
    var size: CGFloat = 48

    var body: some View {
        Circle()
            .fill(day.iconBackgroundColor)
            .frame(width: size, height: size)
            .overlay {
                Image(systemName: day.iconName)
                    .font(.system(size: size * 0.42, weight: .medium))
                    .foregroundStyle(day.iconForegroundColor)
            }
    }
}

#Preview {
    WorkoutDayIconView(day: .chest)
}
