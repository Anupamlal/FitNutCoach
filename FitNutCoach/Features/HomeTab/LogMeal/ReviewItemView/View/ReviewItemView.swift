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
    
    init(barcode: String? = nil, isPresented: Binding<Bool>) {
        _reviewItemViewModel = .init(wrappedValue: .init(barcode: barcode))
        _isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                if let imageurl = reviewItemViewModel.imageUrl {
                    Spacer()
                        .frame(height: 10)
                    
                    AsyncImage(url: URL(string: imageurl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
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
                
                HStack {
                    Text("Meal")
                        .foregroundStyle(Color.textPrimary)
                        .font(.system(size: 15, weight: .semibold))
                    
                    Spacer()
                    
                    Text("Breakfast")
                        .foregroundStyle(Color.textSecondary)
                        .font(.system(size: 15, weight: .regular))
                    
                }
                .frame(height: 48)
                
                Divider()
                
                HStack {
                    Text("Number of Servings")
                        .foregroundStyle(Color.textPrimary)
                        .font(.system(size: 15, weight: .semibold))
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Button("-") {
                            if self.reviewItemViewModel.numberOfServing > 1 {
                                self.reviewItemViewModel.numberOfServing -= 1
                                self.reviewItemViewModel.updateMacrosForServing()
                            }
                        }
                        .disabled(self.reviewItemViewModel.numberOfServing == 1)
                        .font(.system(size: 28, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .frame(width: 36, height: 36, alignment: .center)
                        
                        Divider()
                        
                        Text("\(self.reviewItemViewModel.numberOfServing)")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                            .frame(width: 36, alignment: .center)
                        
                        
                        Divider()
                        
                        Button("+") {
                            self.reviewItemViewModel.numberOfServing += 1
                            self.reviewItemViewModel.updateMacrosForServing()
                        }
                        .font(.system(size: 24, weight: .regular))
                        .frame(width: 36, height: 36, alignment: .center)
                        .foregroundStyle(Color.textSecondary)
                    }
                    .frame(height: 36)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                }
                .frame(height: 48)
                
                Divider()
                
                HStack {
                    Text("Serving Size")
                        .foregroundStyle(Color.textPrimary)
                        .font(.system(size: 15, weight: .semibold))
                    
                    Spacer()
                    
                    Text("\(self.reviewItemViewModel.servingSize.formatToOneDecimalPlaces())g")
                        .foregroundStyle(Color.textSecondary)
                        .font(.system(size: 15, weight: .regular))
                    
                }
                .frame(height: 48)
                
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
                    Text("Daily Goals")
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
                
                
                FNButton(buttonTitle: "Confirm and Add", backgroundEnable: true) {
                    isPresented = false
                }
                .padding(.top, 30)
                
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            if reviewItemViewModel.isLoading {
                FNActivityIndicator()
            }
            
        }
        .onFirstAppear(perform: {
            reviewItemViewModel.setUpFoodCatalogManager(foodCatalogManager: appRootManager.foodCatalogManager)
        })
        .withCustomBackButton(withTitle: "Confirm Food")
    }
}

#Preview {
    ReviewItemView(isPresented: .constant(false))
}
