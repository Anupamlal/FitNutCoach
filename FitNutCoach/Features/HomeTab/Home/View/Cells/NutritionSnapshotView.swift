//
//  NutritionSnapshotView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct NutritionSnapshotView: View {
    
    let profileModel: ProfileModel
    let dailyActivityModel: DailyActivityModel
    
    var body: some View {
        Card {
            HStack() {
                
                VStack(spacing: AppSpacing.xs) {
                    Text(AppTexts.proteinText)
                        .font(.system(size: 13, weight: .medium))
                    
                    Text("\(dailyActivityModel.protein.intValue()) / \(profileModel.proteinTarget.intValue()) g")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Spacer()
                
                VStack(spacing: AppSpacing.xs) {
                    Text(AppTexts.carbsText)
                        .font(.system(size: 13, weight: .medium))
                    Text("\(dailyActivityModel.carbs.intValue()) / \(profileModel.carbTarget.intValue()) g")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Spacer()
                VStack(spacing: AppSpacing.xs) {
                    Text(AppTexts.fatText)
                        .font(.system(size: 13, weight: .medium))
                    Text("\(dailyActivityModel.fat.intValue()) / \(profileModel.fatTarget.intValue()) g")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NutritionSnapshotView(profileModel: ProfileModel(), dailyActivityModel: DailyActivityModel())
}
