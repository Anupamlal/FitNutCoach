//
//  DetectedItemRowView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import SwiftUI

struct DetectedItemRowView: View {
    
    @StateObject var detectedItemRowViewModel: DetectedItemRowViewModel
    var selectedCallback: ((FoodItemModel, Bool) -> Void)?
    
    init(foodItemModel: FoodItemModel, selectedCallback: ((FoodItemModel, Bool) -> Void)? = nil) {
        _detectedItemRowViewModel = .init(wrappedValue: .init(foodItemModel: foodItemModel))
        self.selectedCallback = selectedCallback
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                withAnimation {
                    detectedItemRowViewModel.isSelected.toggle()
                    
                    if let selectedCallback = selectedCallback {
                        selectedCallback(detectedItemRowViewModel.foodItemModel, detectedItemRowViewModel.isSelected)
                    }
                }
                
            } label: {
                Image(systemName: detectedItemRowViewModel.isSelected ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.primaryAccent)
            }
           
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Text(detectedItemRowViewModel.foodItemModel.name ?? "Milk")
                    .foregroundStyle(Color.textPrimary)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(self.detectedItemRowViewModel.getSecondLineText())
                    .foregroundStyle(Color.textSecondary)
                    .font(.system(size: 12, weight: .regular))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(detectedItemRowViewModel.getConfidenceValue() )
                    .foregroundStyle(Color.textSecondary)
                    .font(.system(size: 12, weight: .medium))
                
                FNStepper(counter: $detectedItemRowViewModel.numberOfServing, sizeOfEachVertical: 26, isEnabled: detectedItemRowViewModel.isSelected) {
                    detectedItemRowViewModel.fillUpdatedServingSizes()
                    if let selectedCallback = selectedCallback {
                        selectedCallback(detectedItemRowViewModel.foodItemModel, detectedItemRowViewModel.isSelected)
                    }
                }
                
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DetectedItemRowView(foodItemModel: FoodItemModel())
}
