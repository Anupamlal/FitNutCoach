//
//  DailyGoalsCard.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 11/09/25.
//

import SwiftUI

struct DailyGoalsCard: View {
    
    let goalName: String
    let goalCurrentValue: Int
    let goalColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goalName)
            
            ProgressView(value: Double(goalCurrentValue), total: 100)
                .progressViewStyle(.linear)
                .tint(goalColor)
            
            Text("\(goalCurrentValue)%")
        }
    }
}

#Preview {
    DailyGoalsCard(goalName: AppTexts.caloriesText, goalCurrentValue: 14, goalColor: AppColors.calorieOverTargetColor)
}
