//
//  LogMealMacroView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 13/09/25.
//

import SwiftUI

struct LogMealMacroView: View {
    
    let macroName: String
    let macroValue: String
    let macroColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.s) {
            Text(macroValue)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(macroColor)
            
            Text(macroName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.textSecondary)
        }
    }
}

#Preview {
    LogMealMacroView(macroName: AppTexts.proteinText, macroValue: "66g", macroColor: AppColors.protienColor)
}
