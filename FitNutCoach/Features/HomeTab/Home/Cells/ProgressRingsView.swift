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
    let dailyActivityModel: DailyActivityModel
    var waterIntakeTapCallback:(()->Void)?
    
    var body: some View {
        Card {
            HStack() {
                
                ProgressRingCellView(currentProgressValue: dailyActivityModel.calories, totalValue: profileModel.calorieTarget, currentRingType: .calories)
                Spacer()

                ProgressRingCellView(currentProgressValue: Double(dailyActivityModel.steps), totalValue: Double(profileModel.stepTarget), currentRingType: .steps)
                Spacer()

                ProgressRingCellView(currentProgressValue: dailyActivityModel.waterLiters, totalValue: profileModel.waterTargetLiters, currentRingType: .waterIntake)
                    .onTapGesture {
                        if let waterIntakeTapCallback = waterIntakeTapCallback {
                            waterIntakeTapCallback()
                        }
                    }
                                
            }
            .padding(.horizontal, 20)
        }
    }
}
