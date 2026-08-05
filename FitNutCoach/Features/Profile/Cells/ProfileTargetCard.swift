//
//  ProfileTargetCard.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

struct ProfileTargetCard: View {
    
    let title: String
    let value: String
    let color: Color
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.textSecondary)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.m)
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

#Preview {
    HStack {
        ProfileTargetCard(
            title: "Protein",
            value: "150 g",
            color: AppColors.protienColor,
            backgroundColor: AppColors.protienColor.opacity(0.12)
        )
        ProfileTargetCard(
            title: "Calories",
            value: "2000 kcal",
            color: AppColors.calorieProgressColor,
            backgroundColor: AppColors.calorieTotalColor
        )
    }
    .padding()
}
