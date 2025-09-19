//
//  LogMealView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 13/09/25.
//

import SwiftUI

struct LogMealView: View {
    
    @StateObject var logMealViewModel: LogMealViewModel = .init()
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject var homeNavRouter: Router<HomeRouter>
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView(content: {
                VStack(spacing: AppSpacing.l) {
                    
                    Spacer()
                        .frame(height: AppSpacing.xs)
                    
                    Card(backgroundColor: AppColors.logMealCardBGColor, spacing: AppSpacing.l) {
                        
                        Text("\(self.logMealViewModel.dailyActivityModel?.calories.intValue() ?? 0) / \(self.logMealViewModel.dailyTotalCalories.intValue()) \(AppTexts.kcalText)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        
                        ProgressView(
                            value:
                                self.logMealViewModel.dailyActivityModel?.calories ?? 0 < self.logMealViewModel.dailyTotalCalories ? self.logMealViewModel.dailyActivityModel?.calories : self.logMealViewModel.dailyTotalCalories, total: self.logMealViewModel.dailyTotalCalories)
                            .progressViewStyle(.linear)
                            .tint(AppColors.calorieProgressColor)
                        
                        
                        HStack {
                            
                            LogMealMacroView(macroName: AppTexts.proteinText, macroValue: "\(self.logMealViewModel.dailyActivityModel?.protein.formatToOneDecimalPlaces() ?? "")g", macroColor: AppColors.protienColor)
                            
                            Spacer()
                            
                            LogMealMacroView(macroName: AppTexts.carbsText, macroValue: "\(self.logMealViewModel.dailyActivityModel?.carbs.formatToOneDecimalPlaces() ?? "")g", macroColor: AppColors.carbsColor)
                            
                            Spacer()
                            
                            LogMealMacroView(macroName: AppTexts.fatText, macroValue: "\(self.logMealViewModel.dailyActivityModel?.fat.formatToOneDecimalPlaces() ?? "")g", macroColor: AppColors.fatColor)
                            
                        }
                        
                    }
                    
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        MealTypeView(currentMealType: mealType, foodItems: logMealViewModel.getFoodItemsFor(mealType: mealType)) {
                            self.homeNavRouter.navigate(to: .addFoodItem(selectedMealType: mealType))
                        } menuButtonCallback: {
                            // Show action sheet
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 18)
            })
            .toolbarVisibility(.hidden, for: .tabBar)
            .withCustomBackButton(withTitle: AppTexts.logMealText)
            .onFirstAppear {
                self.logMealViewModel.setDailyActivityManager(appRootManager.dailyActivityManager, appRootManager.profileManager)
            }
        }
        
    }
}

#Preview {
    LogMealView()
}
