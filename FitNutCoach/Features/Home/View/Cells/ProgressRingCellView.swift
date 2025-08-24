//
//  ProgressRingCellView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct ProgressRingCellView: View {
    
    @State var currentProgressValue: Double = 0
    @State var totalValue: Double = 0
    @State var currentRingType: ProgressRingType = .steps
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            ZStack {
                Image(systemName: getImageNameForRing())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(getIconColor())
                
                
                ProgressRing(
                    value: currentProgressValue,
                    total: totalValue,
                    ringWidth: 8,
                    color: getProgressColor(),
                    trackColor: getTotalColor(),
                    overTargetColor: getOverTargetColor(),
                    clockwise: true
                )
                .frame(width: 70, height: 70)
                
            }
            
            Spacer()
                .frame(height: 8)
            
            Text(getTitleText())
                .foregroundStyle(Color.textPrimary)
                .font(.system(size: 17, weight: .semibold))
            
            Text(getSubTitleText())
                .foregroundStyle(Color.textSecondary)
                .font(.system(size: 13, weight: .regular))
            
        }
    }
    
    private func getImageNameForRing() -> String {
        switch currentRingType {
        case .calories:
            return "flame.fill"
        case .steps:
            return "figure.walk"
        case .waterIntake:
            return "drop.fill"
        }
    }
    
    private func getProgressColor() -> Color {
        switch currentRingType {
        case .calories:
            return AppColors.calorieProgressColor
        case .steps:
            return AppColors.stepsProgressColor
        case .waterIntake:
            return AppColors.waterProgressColor
        }
    }
    
    private func getTotalColor() -> Color {
        switch currentRingType {
        case .calories:
            return AppColors.calorieTotalColor
        case .steps:
            return AppColors.stepsTotalColor
        case .waterIntake:
            return AppColors.waterTotalColor
        }
    }
    
    private func getOverTargetColor() -> Color {
        switch currentRingType {
        case .calories:
            return AppColors.calorieOverTargetColor
        case .steps:
            return AppColors.stepsOverTargetColor
        case .waterIntake:
            return AppColors.waterOverTargetColor
        }
    }
    
    private func getSubTitleText() -> String {
        switch currentRingType {
        case .calories:
            return "\(Int(totalValue)) \(AppTexts.kcalText)"
        case .steps:
            return "/ \(Int(totalValue))"
        case .waterIntake:
            return "/ \(totalValue) \(AppTexts.litreText)"
        }
    }
    
    private func getIconColor() -> Color {
        switch currentRingType {
        case .calories:
            return Color.red
        case .steps:
            return Color.green
        case .waterIntake:
            return Color.blue
        }
    }
    
    private func getTitleText() -> String {
        return currentRingType == .waterIntake ? "\(currentProgressValue)" : "\(Int(currentProgressValue))"
    }
}

#Preview {
    ProgressRingCellView(currentProgressValue: 1.0, totalValue: 4.0, currentRingType: .waterIntake)
}
