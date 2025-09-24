//
//  ImageDetectionViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import UIKit

class ImageDetectionViewModel: ObservableObject {

    private let foodDetectorManager: FoodDetectorManager
    private var foodCatalogManager: FoodCatalogManager?
    
    @Published var openReviewDetectFoodItemsView = false
    
    let selectedImage: UIImage
    var detectedFoods: [FoodItemModel] = []
    
    init(foodDetectorManager: FoodDetectorManager = .init(), _ selectedImage: UIImage) {
        self.foodDetectorManager = foodDetectorManager
        self.selectedImage = selectedImage
    }
    
    func loadFoodCatalogManager(_ foodCatalogManager: FoodCatalogManager) {
        self.foodCatalogManager = foodCatalogManager
        
        DispatchQueue.global().async {
            self.detectAllFoods()
        }
    }
    
    private func detectAllFoods() {
        
        self.foodDetectorManager.detectFood(foodCatalogManager: self.foodCatalogManager!, image: selectedImage) {[weak self] allFoodModels in
            
            guard let weakSelf = self else { return }
            weakSelf.detectedFoods = allFoodModels
            
            DispatchQueue.main.runInMainThread {
                weakSelf.openReviewDetectFoodItemsView = true
            }
        }
    }
}
