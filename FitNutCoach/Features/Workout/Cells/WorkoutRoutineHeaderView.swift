//
//  WorkoutRoutineHeaderView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 08/08/26.
//

import SwiftUI

struct WorkoutRoutineHeaderView: View {

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.m) {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Group {
                    Text("Excited for your ")
                        .foregroundStyle(Color.textPrimary)
                    + Text("new journey?")
                        .foregroundStyle(Color.primaryAccent)
                    + Text(" 🎉")
                        .foregroundStyle(Color.textPrimary)
                }
                .font(.system(size: 26, weight: .bold))
                .fixedSize(horizontal: false, vertical: true)

                Text("Let's build your workout routine.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.textSecondary)

                Group {
                    Text("Select your workout days in the ")
                        .foregroundStyle(Color.textSecondary)
                    + Text("order")
                        .foregroundStyle(Color.primaryAccent)
                    + Text(" you want to follow them.")
                        .foregroundStyle(Color.textSecondary)
                }
                .font(.system(size: 14, weight: .regular))
                .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            headerIllustration
        }
    }

    private var headerIllustration: some View {
        ZStack {
            Circle()
                .fill(Color.primaryAccent.opacity(0.12))
                .frame(width: 110, height: 110)

            Circle()
                .fill(Color.primaryAccent)
                .frame(width: 36, height: 36)
                .overlay {
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .offset(x: -28, y: -30)

            Image("activityMonitor")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .offset(x: 8, y: 4)

            Image(systemName: "sparkle")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color(hex: 0xFACC15))
                .offset(x: 40, y: -35)

            Image(systemName: "sparkle")
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Color(hex: 0xFACC15))
                .offset(x: -42, y: 20)
        }
        .frame(width: 120, height: 120)
    }
}

#Preview {
    WorkoutRoutineHeaderView()
        .padding()
}
