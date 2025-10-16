//
//  NudgeDetailCellView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 11/10/25.
//

import SwiftUI

struct NudgeDetailCellView: View {
    var body: some View {
        Card(backgroundColor: .white) {
            VStack {
                HStack {
                    Text("💧")
                        .font(.system(size: 30, weight: .bold))
                    
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Hyrdration Boost")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        Text("It's 32°C outside. Drink a glass of water to stay hydrated.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                }
                
                
                HStack {
                    FNButton(buttonTitle: "Mark Done", backgroundEnable: true, buttonHeight: 40) {
                        
                    }
                    
                    FNButton(buttonTitle: "Snooze", backgroundEnable: false, buttonHeight: 40) {
                        
                    }
                }
                
            }
            .padding(.horizontal, 8)
            
        }
    }
}

#Preview {
    NudgeDetailCellView()
}
