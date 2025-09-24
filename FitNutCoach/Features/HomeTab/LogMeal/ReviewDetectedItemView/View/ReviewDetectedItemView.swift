//
//  ReviewDetectedItemView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import SwiftUI

struct ReviewDetectedItemView: View {
    
    @StateObject var reviewDetectedItemViewModel: ReviewDetectedItemViewModel
    
    init(selectedItemImage: UIImage, detectedFoodItems: [FoodItemModel]) {
        _reviewDetectedItemViewModel = StateObject(wrappedValue: .init(selectedItemImage: selectedItemImage, detectedFoodItems: detectedFoodItems))
    }
    
    var body: some View {
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
                    
                    Text("Select the closest food item")
                        .font(.system(size: 18, weight: .medium))
                        .padding(.bottom, 8)
                        .padding(.horizontal, 24)
                    
                    ForEach(reviewDetectedItemViewModel.detectedFoodItems, id: \.self) { currentFood in
                        
                        DetectedItemRowView(foodItemModel: currentFood, selectedCallback: { foodItemModel in
                            if let firstIndex = reviewDetectedItemViewModel.selectedFoodItems.firstIndex(of: foodItemModel) {
                                reviewDetectedItemViewModel.selectedFoodItems.remove(at: firstIndex)
                            }else {
                                reviewDetectedItemViewModel.selectedFoodItems.append(foodItemModel)
                            }
                        })
                        .padding(.vertical, 8)
                        
                        Divider()
                            .padding(.horizontal, 24)
                    }
                    
                }
            }
            
            VStack(spacing: 0) {
                FNButton(buttonTitle: AppTexts.confirmText, backgroundEnable: true, isEnabled: reviewDetectedItemViewModel.shouldShowConfirmButton) {
                    
                }
                
                Spacer()
                    .frame(height: 10)
                
                Text("Not satisfied with the detection?")
                    .font(.system(size: 12, weight: .medium))
                
                Spacer()
                    .frame(height: 4)
                
                Button {
                    
                    
                } label: {
                    Text("Detect with AI (10 left for today)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.primaryAccent)
                }

                
            }
            .padding(.horizontal, 24)
        }
        .withCustomBackButton(withTitle: AppTexts.detectedFoodsText)
    }
}

#Preview {
    ReviewDetectedItemView(selectedItemImage: UIImage(), detectedFoodItems: [FoodItemModel]())
}
