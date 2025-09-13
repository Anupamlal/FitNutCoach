//
//  LogMealView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 13/09/25.
//

import SwiftUI

struct LogMealView: View {
    
    @State var openAddFoodView: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView(content: {
                VStack(spacing: AppSpacing.l) {
                    
                    Spacer()
                        .frame(height: AppSpacing.l)
                    
                    Card(backgroundColor: AppColors.logMealCardBGColor, spacing: AppSpacing.l) {
                        
                        Text("1200 / 2000 kcal")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        
                        ProgressView(value: 1200, total: 2000)
                        
                            .progressViewStyle(.linear)
                            .tint(AppColors.calorieProgressColor)
                        
                        
                        HStack {
                            
                            LogMealMacroView(macroName: AppTexts.proteinText, macroValue: "63g", macroColor: AppColors.protienColor)
                            
                            Spacer()
                            
                            LogMealMacroView(macroName: AppTexts.carbsText, macroValue: "170g", macroColor: AppColors.carbsColor)
                            
                            Spacer()
                            
                            LogMealMacroView(macroName: AppTexts.fatText, macroValue: "90g", macroColor: AppColors.fatColor)
                            
                        }
                        
                    }
                    
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        MealTypeView(currentMealType: mealType, foodItems: []) {
                            openAddFoodView = true
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            })
            .toolbarVisibility(.hidden, for: .tabBar)
            .withCustomBackButton(withTitle: AppTexts.logMealText)
            .navigationDestination(isPresented: $openAddFoodView) {
                AddFoodItemView()
            }
        }
        
    }
}

#Preview {
    LogMealView()
}
