//
//  FoodItemView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import SwiftUI

struct FoodItemView: View {
    
    let foodItemName: String
    let brandName: String?
    let servingSize: String
    let numberOfServing: Int
    let totalCalories: String
    let isForSelection: Bool
    
    @State private var isSelected: Bool = false
    var onSelection: ((Bool) -> Void)?
     
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                Text("\(foodItemName)\(brandName != nil ? ", \(brandName!)" : "")")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.textPrimary)
                    .lineLimit(1)
                
                Text("Servings: \(numberOfServing), \(servingSize)")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.textSecondary)
            }
            
            Spacer()
            
            Text(totalCalories)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(Color.textSecondary)
                .padding(.trailing, 4)
            
            Button {
                if isForSelection {
                    isSelected = !isSelected
                }
                onSelection?(isSelected)
                
            } label: {
                Image(systemName: getButtonImage())
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.primaryAccent)
            }

        }
    }
    
    private func getButtonImage() -> String {
        if isForSelection {
            if isSelected {
                return "checkmark.square"
            }else {
                return "plus.app"
            }
            
        }else {
            return "ellipsis.circle"
        }
    }
}

#Preview {
    FoodItemView(foodItemName: "", brandName: nil, servingSize:"0g", numberOfServing: 1, totalCalories: "0kcal", isForSelection: false)
}
