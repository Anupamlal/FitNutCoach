//
//  ImageDetectionView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 19/09/25.
//

import SwiftUI

struct ImageDetectionView: View {
    
    @StateObject var imageDetectionViewModel: ImageDetectionViewModel
    @EnvironmentObject var appRootManager: AppRootManager
    
    init(selectedImage: UIImage) {
        _imageDetectionViewModel = StateObject(wrappedValue: ImageDetectionViewModel(selectedImage))
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                Color.black
                
                Image(uiImage: imageDetectionViewModel.selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 5)
                
                ProgressView {
                    Text(AppTexts.identifyingFoodText)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.white)
                }
                .tint(Color.white)
            }
            .edgesIgnoringSafeArea(.all)
            .withCustomBackButton(withTitle: "", backButtonTint: .white, backButtonType: .close)
            .onAppear {
                detectImage()
            }
            .navigationDestination(isPresented: $imageDetectionViewModel.openReviewDetectFoodItemsView) {
                ReviewDetectedItemView(selectedItemImage: imageDetectionViewModel.selectedImage, detectedFoodItems: imageDetectionViewModel.detectedFoods)
            }
        }
        
    }
    
    func detectImage() {
        self.imageDetectionViewModel.loadFoodCatalogManager(appRootManager.foodCatalogManager)
    }
}

#Preview {
    ImageDetectionView(selectedImage: UIImage())
}
