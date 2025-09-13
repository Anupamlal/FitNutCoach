//
//  MealTypeView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 13/09/25.
//

import SwiftUI

struct MealTypeView: View {
    
    let currentMealType: MealType
    let foodItems: [FoodItemModel]
    var addButtonCallback: (()->Void)?
    
    var body: some View {
        Card(backgroundColor: Color.white) {
            
            VStack {
                HStack(spacing: 7) {
                    Card(backgroundColor: Color.primaryAccent, padding: AppSpacing.xs, cornerRadius: 8) {
                        Image(systemName: getIcon())
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color.white)
                    }
                    
                    Text(currentMealType.getDisplayName())
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                    
                    Spacer()
                    
                    if let totalCaloriesText = getTotalCalories() {
                        Text(totalCaloriesText)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Button {
                        if let addButtonCallback = addButtonCallback {
                            addButtonCallback()
                        }
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.primaryAccent)
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                if foodItems.count > 0 {
                    
                }else {
                    Text(getTextForNoFoodItems())
                        .padding(.vertical, 36)
                        .foregroundStyle(Color.textSecondary)
                        .font(.system(size: 12, weight: .regular))
                }
            }
        }
    }
    
    func getIcon() -> String {
        switch currentMealType {
        case .breakfast:
            return "sunrise.fill"
            
        case .lunch:
            return "sun.max"
            
        case .dinner:
            return "moon.fill"
            
        case .snack:
            return "cup.and.saucer.fill"
        }
    }
    
    func getTextForNoFoodItems() -> String {
        switch currentMealType {
        case .breakfast:
            return AppTexts.breakFastDescriptionText
            
        case .lunch:
            return AppTexts.lunchDescriptionText
            
        case .dinner:
            return AppTexts.dinnerDescriptionText
            
        case .snack:
            return AppTexts.snacksDescriptionText
        }
    }
    
    func getTotalCalories() -> String? {
    
        guard !foodItems.isEmpty else {
            return nil
        }
    
        let totalCalories = self.foodItems.reduce(0, {$0+$1.calories})
        
        return "\(totalCalories.formatToOneDecimalPlaces()) \(AppTexts.kcalText)"
    }
}

#Preview {
    MealTypeView(currentMealType: .snack, foodItems: [])
}
