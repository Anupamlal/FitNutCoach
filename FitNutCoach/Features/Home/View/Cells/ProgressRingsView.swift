//
//  ProgressRingsView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

enum ProgressRingType {
    case calories
    case steps
    case waterIntake
}

struct ProgressRingsView: View {
    
    let profileModel: ProfileModel
    
    var body: some View {
        Card {
            HStack() {
                
                ProgressRingCellView(currentProgressValue: 1350, totalValue: profileModel.calorieTarget, currentRingType: .calories)
                Spacer()

                ProgressRingCellView(currentProgressValue: 7500, totalValue: Double(profileModel.stepTarget), currentRingType: .steps)
                Spacer()

                ProgressRingCellView(currentProgressValue: 1.0, totalValue: profileModel.waterTargetLiters, currentRingType: .waterIntake)
                                
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ProgressRingsView(profileModel: ProfileModel())
}
