//
//  WorkoutSetupCell.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 16/08/26.
//

import SwiftUI

struct WorkoutSetupCell: View {

    let dayLabel: String
    let statusText: String
    let isConfigured: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.divider, lineWidth: 1)
                .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 12)))
                .frame(height: 48)
                .overlay {
                    HStack(spacing: AppSpacing.m) {
                        Text(dayLabel)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.primaryAccent)
                            .frame(width: 44, alignment: .leading)

                        Text(statusText)
                            .font(.system(size: 15, weight: isConfigured ? .medium : .regular))
                            .foregroundStyle(isConfigured ? Color.textPrimary : Color.textSecondary)
                            .lineLimit(1)

                        Spacer(minLength: 0)

                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.primaryAccent)
                    }
                    .padding(.horizontal, AppSpacing.l)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: AppSpacing.xs) {
        WorkoutSetupCell(
            dayLabel: "MON",
            statusText: "Tap to add muscles",
            isConfigured: false,
            onTap: {}
        )
        WorkoutSetupCell(
            dayLabel: "TUE",
            statusText: "Chest, Back",
            isConfigured: true,
            onTap: {}
        )
    }
    .padding()
}
