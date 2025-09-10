//
//  ReviewItemView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 07/09/25.
//

import SwiftUI

struct ReviewItemView: View {
    
    @StateObject var reviewItemViewModel: ReviewItemViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    
    
    init(barcode: String? = nil) {
        _reviewItemViewModel = .init(wrappedValue: .init(barcode: barcode))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 12) {
                    HStack(spacing: 15) {
                        Card(backgroundColor: AppColors.foodCardBGColor, content: {
                            AsyncImage(url: URL(string: reviewItemViewModel.reviewItem?.imageUrl ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Color.red
                            }
                            .frame(width: 80, height: 80)
                        })
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(reviewItemViewModel.reviewItem?.name ?? "")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color.textPrimary)
                            
                            Text(reviewItemViewModel.reviewItem?.brand ?? "")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color.textSecondary)
                        }
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 12){
                        Card(backgroundColor: AppColors.foodCardBGColor, content: {
                            VStack(spacing: 4) {
                                Text("\(reviewItemViewModel.reviewItem?.caloriesPer100G ?? 0)")
                                    .padding(.top, 8)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                
                                Text("Calories")
                                    .padding(.bottom, 4)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        })
                        
                        Card(backgroundColor: AppColors.foodCardBGColor, content: {
                            VStack(spacing: 4) {
                                Text("\(reviewItemViewModel.reviewItem?.proteinPer100G ?? 0)g")
                                    .padding(.top, 8)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                
                                Text(AppTexts.proteinText)
                                    .padding(.bottom, 4)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        })
                        
                        Card(backgroundColor: AppColors.foodCardBGColor, content: {
                            VStack(spacing: 4) {
                                Text("\(reviewItemViewModel.reviewItem?.carbsPer100G ?? 0)g")
                                    .padding(.top, 8)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                
                                Text(AppTexts.carbsText)
                                    .padding(.bottom, 4)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        })
                        
                        Card(backgroundColor: AppColors.foodCardBGColor, content: {
                            VStack(spacing: 4) {
                                Text("\(reviewItemViewModel.reviewItem?.fatPer100G ?? 0)g")
                                    .padding(.top, 8)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                
                                Text(AppTexts.fatText)
                                    .padding(.bottom, 4)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                        })
                       
                    }
                    
                    VStack(alignment: .leading) {
                        
                        Text("Add to meal")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Breakfast")
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundStyle(Color.textPrimary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundStyle(Color.textPrimary)
                            }
                            .frame(height: 48)
                            .padding(.horizontal, 12)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            }
                        }


                    }
                    .padding(.top)
                    
                    
                    FNButton(buttonTitle: "Confirm and Add", backgroundEnable: true) {
                        
                    }
                    .padding(.top, 30)
                    
                    Button {
                        
                    } label: {
                        Text(AppTexts.cancelText)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.primaryAccent)
                    }

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
}

#Preview {
    ReviewItemView()
}
