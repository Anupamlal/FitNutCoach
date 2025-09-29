//
//  ReviewDetectedItemView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import SwiftUI

struct ReviewDetectedItemConfig: Equatable, Hashable {
    let selectedItemImage: UIImage
    let detectedFoodItems: [FoodItemModel]
}

struct ReviewDetectedItemView: View {
    
    @StateObject var reviewDetectedItemViewModel: ReviewDetectedItemViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject var homeNavRouter: Router<HomeRouter>
    
    init(reviewDetectedItemConfig: ReviewDetectedItemConfig) {
        _reviewDetectedItemViewModel = StateObject(wrappedValue: .init(selectedItemImage: reviewDetectedItemConfig.selectedItemImage, detectedFoodItems: reviewDetectedItemConfig.detectedFoodItems))
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                            .frame(height: 4)
                        
                        Image(uiImage: reviewDetectedItemViewModel.selectedItemImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                            .frame(height: 16)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(AppTexts.selectTheClosestFoodItemText)
                                    .font(.system(size: 18, weight: .medium))
                                    .padding(.bottom, 8)
                                
                                if reviewDetectedItemViewModel.isFoodDetectedUsingAI{
                                    Text(AppTexts.detectedUsingAIText)
                                        .font(.system(size: 12, weight: .medium))
                                        .italic()
                                        .foregroundStyle(Color.textSecondary)
                                }
                            }
                                
                            Spacer()
                            
                            Button {
                                reviewDetectedItemViewModel.openMealTypeSelection = true
                            } label: {
                                HStack(spacing: 4) {
                                    Text(reviewDetectedItemViewModel.currentMealType.getDisplayName())
                                    Image(systemName: "chevron.down")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 5)
                                        
                                }
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color.textSecondary)
                                .padding(.all, 8)
                                .padding(.horizontal, 4)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(AppColors.logMealCardBGColor)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(height: 10)
                        
                        ForEach(reviewDetectedItemViewModel.detectedFoodItems, id: \.self) { currentFood in
                            
                            DetectedItemRowView(foodItemModel: currentFood, selectedCallback: { (foodItemModel, isSelected)  in
                                
                                if isSelected {
                                    if let firstIndex = reviewDetectedItemViewModel.selectedFoodItems.firstIndex(where: {$0.id == foodItemModel.id}) {
                                        reviewDetectedItemViewModel.selectedFoodItems.remove(at: firstIndex)
                                    }
                                    reviewDetectedItemViewModel.selectedFoodItems.append(foodItemModel)
                                    
                                }else {
                                    if let firstIndex = reviewDetectedItemViewModel.selectedFoodItems.firstIndex(of: foodItemModel) {
                                        reviewDetectedItemViewModel.selectedFoodItems.remove(at: firstIndex)
                                    }
                                }
                            })
                            .padding(.vertical, 8)
                            
                            Divider()
                                .padding(.horizontal, 20)
                        }
                        
                    }
                }
                
                VStack(spacing: 0) {
                    FNButton(buttonTitle: AppTexts.confirmText, backgroundEnable: true, isEnabled: reviewDetectedItemViewModel.shouldShowConfirmButton) {
                        homeNavRouter.navigateBack()
                        Task {
                            _ = await self.reviewDetectedItemViewModel.logSelectedFood()
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    if reviewDetectedItemViewModel.numberOfAIDetectionLeft > 0 && reviewDetectedItemViewModel.isFoodDetectedUsingAI == false {
                        
                        Text(AppTexts.notSatisfiedWithTheDetectionText)
                            .font(.system(size: 12, weight: .medium))
                        
                        Spacer()
                            .frame(height: 4)
                        
                        Button {
                            reviewDetectedItemViewModel.detectWithAI()
                            
                        } label: {
                            Text(String(format: AppTexts.detectWithAIText, "\(reviewDetectedItemViewModel.numberOfAIDetectionLeft)"))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Color.primaryAccent)
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
            }
            
            if reviewDetectedItemViewModel.isLoading {
                FNActivityIndicator()
            }
        }
        .withCustomBackButton(withTitle: AppTexts.detectedFoodsText)
        .onFirstAppear() {
            reviewDetectedItemViewModel.setup(appRootManager.dailyActivityManager)
        }
        .sheet(isPresented: $reviewDetectedItemViewModel.openMealTypeSelection) {
            SelectMealTypeBottomSheet(selectedMealType: $reviewDetectedItemViewModel.currentMealType)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    ReviewDetectedItemView(reviewDetectedItemConfig: ReviewDetectedItemConfig(selectedItemImage: UIImage(), detectedFoodItems: [FoodItemModel]()))
}
