//
//  LogMealOptionView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/09/25.
//

import SwiftUI

struct LogMealOptionView: View {
    
    var mealSourceType: MealSourceType
    var mealSourceCallback:((MealSourceType)-> Void)?
    
    var body: some View {
        Button {
            
            if let mealSourceCallback = self.mealSourceCallback {
                mealSourceCallback(mealSourceType)
            }
            
        } label: {
            Card(borderEnable: true) {
                HStack(spacing: 12) {
                    Image(systemName: getImageName())
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(getAccentColor())
                        .frame(width: 22, height: 22)
                        .padding(.all, 7)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(getAccentColor().opacity(0.2))
                        }
                    
                                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(getOptionTitle())
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                                            
                        
                        Text(getOptionSubtitle())
                            .foregroundStyle(Color.textSecondary)
                            .font(.system(size: 13))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                        .foregroundStyle(Color.gray)
                }
            }
        }
    }
    
    private func getImageName() -> String {
        switch mealSourceType {
        case .photo:
            return "camera.fill"

        case .barcode:
            return "barcode.viewfinder"
            
        case .manual:
            return "pencil.circle"
        }
    }
    
    private func getOptionTitle() -> String {
        switch mealSourceType {
        case .photo:
            return AppTexts.snapAPhotoText
            
        case .barcode:
            return AppTexts.scanABarCodeText
            
        case .manual:
            return AppTexts.addManuallyText
        }
    }
    
    private func getOptionSubtitle() -> String {
        switch mealSourceType {
        case .photo:
            return AppTexts.useAItoDetectFoodsText
            
        case .barcode:
            return AppTexts.foodViaBarcodeText
            
        case .manual:
            return AppTexts.searchOrCreateFoodText
        }
    }
    
    private func getAccentColor() -> Color {
        switch mealSourceType {
        case .photo:
            return AppColors.waterProgressColor
            
        case .barcode:
            return AppColors.barcodeReaderColor
            
        case .manual:
            return AppColors.manualReaderColor
        }
    }
}

#Preview {
    LogMealOptionView(mealSourceType: .photo)
}
