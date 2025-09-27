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
    @Environment(\.dismiss) var dismiss
    
    var imageDetectionCallback: ((_ detectedFoods: [FoodItemModel]) -> Void)?
    
    init(selectedImage: UIImage, imageDetectionCallback: ((_ detectedFoods: [FoodItemModel]) -> Void)? = nil) {
        _imageDetectionViewModel = StateObject(wrappedValue: ImageDetectionViewModel(selectedImage))
        self.imageDetectionCallback = imageDetectionCallback
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                Color.black
                
                Image(uiImage: imageDetectionViewModel.selectedImage!)
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
            .onFirstAppear() {
                detectImage()
            }
        }
        
    }
    
    func detectImage() {
        self.imageDetectionViewModel.loadFoodCatalogManager(appRootManager.foodCatalogManager){ result in
            if result {
                DispatchQueue.main.runInMainThread {
                    imageDetectionCallback?(self.imageDetectionViewModel.detectedFoods)
                    self.dismiss()
                }
            }else {
                /// Fallback case needs to be written
            }
        }
    }
}

#Preview {
    ImageDetectionView(selectedImage: UIImage())
}
