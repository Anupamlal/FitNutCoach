//
//  WorkoutHomeView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/08/26.
//

import SwiftUI

struct WorkoutHomeView: View {

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: AppSpacing.m) {
                Text(AppTexts.workoutHomeTitleText)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.textPrimary)

                Text(AppTexts.workoutHomeSubtitleText)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.textSecondary)
            }
            .padding()
        }
    }
}

#Preview {
    WorkoutHomeView()
}
