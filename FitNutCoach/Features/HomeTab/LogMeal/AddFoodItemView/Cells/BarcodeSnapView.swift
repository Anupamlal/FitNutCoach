//
//  BarcodeSnapView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import SwiftUI

struct BarcodeSnapView: View {
    
    var barcodeButtonCallback:(()->Void)?
    
    var body: some View {
        Button {
            barcodeButtonCallback?()
            
        } label: {
            Card(backgroundColor: AppColors.logMealCardBGColor) {
                HStack() {
                    VStack(alignment: .leading, spacing: AppSpacing.s){
                        Text(AppTexts.scanABarCodeText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.textPrimary)
                        
                        Text(AppTexts.foodViaBarcodeText)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "barcode.viewfinder")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.primaryAccent)
                    
                }
            }
        }
        .padding(.top, AppSpacing.s)
    }
}

#Preview {
    BarcodeSnapView()
}
