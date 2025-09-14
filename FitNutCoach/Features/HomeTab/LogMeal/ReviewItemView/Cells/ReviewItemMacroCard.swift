//
//  ReviewItemMacroCard.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 11/09/25.
//

import SwiftUI

struct ReviewItemMacroCard: View {
    
    let macroName: String
    let macroValue: String
    let macroPercentageByTotal: String
    let cardBGColor: Color
    
    var body: some View {
        VStack {
            Card(backgroundColor: cardBGColor, content: {
                VStack(spacing: 6) {
                    Text(macroValue)
                        .font(.system(size: 17, weight: .medium))
                    
                    if !macroPercentageByTotal.isEmpty {
                        Text(macroPercentageByTotal)
                            .font(.system(size: 14, weight: .regular))
                    }
                }
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            })
            .frame(height: 80)
            
            Text(macroName)
                .foregroundStyle(Color.textSecondary)
                .font(.system(size: 14, weight: .regular))
        }
    }
}

#Preview {
    ReviewItemMacroCard(macroName: AppTexts.caloriesText, macroValue: "170", macroPercentageByTotal: "17%", cardBGColor: AppColors.calorieProgressColor)
}
