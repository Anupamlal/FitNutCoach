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
    var menuButtonCallback: (()->Void)?
    
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
                    .frame(height: 15)
                
                if foodItems.count > 0 {
                    ForEach(foodItems, id: \.id) { item in
                        FoodItemView(foodItemName: item.name!, brandName: item.brand, servingSize: "\(item.servingSize.formatToOneDecimalPlaces())\(item.servingUnit ?? "g")", totalCalories: "\(item.calories.formatToOneDecimalPlaces())\(AppTexts.kcalText)", isForSelection: false, onSelection: {_ in 
                            menuButtonCallback?()
                        })
                        .padding(.bottom, 10)
                    }
                    
                }else {
                    Text(getTextForNoFoodItems())
                        .padding(.vertical, 26)
                        .foregroundStyle(Color.textSecondary)
                        .font(.system(size: 12, weight: .regular))
                }
                
                Spacer()
                    .frame(height: 5)
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
