//
//  WorkoutIntroFeatureRow.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/08/26.
//

import SwiftUI

struct WorkoutIntroFeatureRow: View {

    let iconName: String
    let title: String

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Circle()
                .fill(Color.primaryAccent.opacity(0.12))
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.primaryAccent)
                }

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.textSecondary)

            Spacer(minLength: 0)
        }
    }
}

#Preview {
    WorkoutIntroFeatureRow(iconName: "person.fill", title: AppTexts.workoutIntroFeaturePersonalizedText)
        .padding()
}
