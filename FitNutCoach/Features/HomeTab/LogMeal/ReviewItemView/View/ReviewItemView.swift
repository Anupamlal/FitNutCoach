//
//  ReviewItemView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 07/09/25.
//

import SwiftUI

struct ReviewItemView: View {
    
    @StateObject var reviewItemViewModel: ReviewItemViewModel
    @State var counter: Int = 1
    @EnvironmentObject private var appRootManager: AppRootManager
    @Binding var isPresented: Bool
    
    init(barcode: String? = nil, isPresented: Binding<Bool>, mealType: MealType) {
        _reviewItemViewModel = .init(wrappedValue: .init(barcode: barcode, mealType: mealType))
        _isPresented = isPresented
    }
    
    var body: some View {
            
        Group {
            if reviewItemViewModel.isLoading {
                FNActivityIndicator()
                
            }else if let errrorString = reviewItemViewModel.errorString {
                Text(errrorString)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.textPrimary)
                
            }else {
                VStack(spacing: 0) {
                    
                    if let imageurl = reviewItemViewModel.imageUrl {
                        Spacer()
                            .frame(height: 10)
                        
                        FNCachedAsyncImage(url: URL(string: imageurl), contentMode: .fit) {
                            Image("foodPlaceholderImage")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .foregroundStyle(Color.divider)
                                .frame(width: 120, height: 120)
                        }
                        .frame(width: 120, height: 120)
                        
                    }
                    
                    Spacer()
                        .frame(height: 15)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(reviewItemViewModel.reviewItem?.name ?? "")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                        
                        Text(reviewItemViewModel.reviewItem?.brand ?? "")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Spacer()
                        .frame(height: 12)
                    
                    Divider()
                                        
                    FNKeyValueView(keyName: AppTexts.mealText, valueName: reviewItemViewModel.mealType.getDisplayName())
                    
                    Divider()
                    
                    HStack {
                        Text(AppTexts.numberOfServingsText)
                            .foregroundStyle(Color.textPrimary)
                            .font(.system(size: 15, weight: .semibold))
                        
                        Spacer()
                        
                        FNStepper(counter: $reviewItemViewModel.numberOfServing) {
                            self.reviewItemViewModel.updateMacrosForServing()
                        }
                        
                    }
                    .frame(height: 48)
                    
                    Divider()
                    
                    FNKeyValueView(keyName: AppTexts.servingSizeText, valueName: "\(self.reviewItemViewModel.servingSize.formatToOneDecimalPlaces())\(self.reviewItemViewModel.reviewItem?.servingUnit ?? "g")")
                                            
                    Divider()
                    
                    Spacer()
                        .frame(height: 12)
                    
                    HStack(spacing: 12){
                        
                        ReviewItemMacroCard(
                            macroName: AppTexts.caloriesText,
                            macroValue: "\(reviewItemViewModel.totalCalories.formatToOneDecimalPlaces())",
                            macroPercentageByTotal: "",
                            cardBGColor: AppColors.calorieColor
                        )
                        
                        ReviewItemMacroCard(
                            macroName: AppTexts.proteinText,
                            macroValue: "\(reviewItemViewModel.totalProtien.formatToOneDecimalPlaces())g",
                            macroPercentageByTotal: reviewItemViewModel.reviewItem?.getProtienPercentageInTotalCalorie() ?? "",
                            cardBGColor: AppColors.protienColor
                        )
                        
                        ReviewItemMacroCard(
                            macroName: AppTexts.carbsText,
                            macroValue: "\(reviewItemViewModel.totalCarbs.formatToOneDecimalPlaces())g",
                            macroPercentageByTotal: reviewItemViewModel.reviewItem?.getCarbsPercentageInTotalCalorie() ?? "",
                            cardBGColor: AppColors.carbsColor
                        )
                        
                        ReviewItemMacroCard(
                            macroName: AppTexts.fatText,
                            macroValue: "\(reviewItemViewModel.totalFat.formatToOneDecimalPlaces())g",
                            macroPercentageByTotal: reviewItemViewModel.reviewItem?.getFatPercentageInTotalCalorie() ?? "",
                            cardBGColor: AppColors.fatColor
                        )
                        
                    }
                    
                    Spacer()
                        .frame(height: 12)
                    
                    Divider()
                    
                    Spacer()
                        .frame(height: 12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(AppTexts.dailyGoalsText)
                            .font(.system(size: 15, weight: .semibold))
                        
                        
                        HStack(spacing: 12) {
                            DailyGoalsCard(goalName: AppTexts.caloriesText, goalCurrentValue: 14, goalColor: AppColors.calorieColor)
                            
                            DailyGoalsCard(goalName: AppTexts.proteinText, goalCurrentValue: 17, goalColor: AppColors.protienColor)
                            
                            DailyGoalsCard(goalName: AppTexts.carbsText, goalCurrentValue: 17, goalColor: AppColors.carbsColor)
                            
                            DailyGoalsCard(goalName: AppTexts.fatText, goalCurrentValue: 17, goalColor: AppColors.fatColor)
                            
                        }
                        .font(.system(size: 14, weight: .regular))
                        
                    }
                    .foregroundStyle(Color.textSecondary)
                    
                    Spacer()
                        .frame(height: 12)
                    
                    
                    FNButton(buttonTitle: AppTexts.confirmAndAddText, backgroundEnable: true) {
                        isPresented = false
                        self.reviewItemViewModel.fillUpdatedServingSizes()
                        Task {
                            _ = await reviewItemViewModel.confirmFoodAndUpdate()
                        }
                    }
                    .padding(.top, 30)
                    
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

            }
        }
        .onFirstAppear(perform: {
            reviewItemViewModel.setUpFoodCatalogManager(foodCatalogManager: appRootManager.foodCatalogManager, dailyActivityManager: appRootManager.dailyActivityManager)
        })
        .withCustomBackButton(withTitle: AppTexts.confirmFoodText)
    }
}

#Preview {
    ReviewItemView(isPresented: .constant(false), mealType: .breakfast)
}
