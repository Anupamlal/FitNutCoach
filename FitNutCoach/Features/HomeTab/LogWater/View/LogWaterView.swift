//
//  LogWaterView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 31/08/25.
//

import SwiftUI

struct LogWaterView: View {
    
    @State var counter: Double = 0
    
    let totalWaterTarget: Double
    @Environment(\.dismiss) var dismiss
    var dailyactvityManager: DailyActivityManager
    
    var body: some View {
            VStack {
                
                Text(AppTexts.logWaterIntakeText)
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.bottom, 5)
                                    
                
                Text(AppTexts.trackYourHyrdrationText)
                    .font(.system(size: 14))
                
                Spacer()
                    .frame(height: 30)
                
                ZStack {
                    ProgressRing(value: 0.25*counter, total: totalWaterTarget, ringWidth: 10, color: AppColors.waterProgressColor, trackColor: AppColors.waterTotalColor, overTargetColor: AppColors.waterOverTargetColor, clockwise: true)
                        .frame(width: 120, height: 120)
                    
                    Text(getWaterIntakeValueText())
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Stepper(value: $counter, in: 0...1000) {
                    Text(AppTexts.twoFiftyMLText)
                }
                
                Spacer()
                    .frame(height: 30)
                
                FNButton(buttonTitle: AppTexts.saveText, backgroundEnable: true) {
                    Task {
                        await dailyactvityManager.addWatersIntake(counter*0.25)
                    }
                    dismiss()
                }
                
                Spacer()
                    .frame(height: 15)
                
                FNButton(buttonTitle: AppTexts.cancelText, backgroundEnable: false) {
                    dismiss()
                }
            }
            .padding(.all, 30)
        
    }
    
    func getWaterIntakeValueText() -> String {
        let waterIntakeValue = 0.25 * counter
        
        guard waterIntakeValue > 0 else {
            return "0 ml"
        }
            
        if waterIntakeValue < 1 {
            return String(format: "%.2f ml", waterIntakeValue)
            
        }
        return String(format: "%.2f l", waterIntakeValue)
        
    }
}

#Preview {
    LogWaterView(totalWaterTarget: 4.0, dailyactvityManager: DailyActivityManager(container: PersistenceController.shared.container))
}
