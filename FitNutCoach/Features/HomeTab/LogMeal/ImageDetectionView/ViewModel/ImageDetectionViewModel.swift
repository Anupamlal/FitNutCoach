//
//  ImageDetectionViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import UIKit

class ImageDetectionViewModel: ObservableObject {

    private var foodDetectorManager: FoodDetectorManager?
    private var foodCatalogManager: FoodCatalogManager?
        
    var selectedImage: UIImage?
    var detectedFoods: [FoodItemModel] = []
    
    init(_ selectedImage: UIImage) {
        self.foodDetectorManager = .init()
        self.selectedImage = selectedImage
    }
    
    deinit {
        self.foodDetectorManager = nil
        self.foodCatalogManager = nil
        detectedFoods = []
        selectedImage = nil
        print("ImageDetectionViewModel deinit")
    }
    
    func loadFoodCatalogManager(_ foodCatalogManager: FoodCatalogManager, completion: @escaping (Bool)->Void) {
        self.foodCatalogManager = foodCatalogManager
        
        DispatchQueue.global().async {[weak self] in
            self?.detectAllFoods(completion: completion)
        }
    }
    
    private func detectAllFoods(completion: @escaping (Bool)->Void){
        
        self.foodDetectorManager?.detectFood(foodCatalogManager: self.foodCatalogManager!, image: selectedImage!) {[weak self] allFoodModels in
            
            guard let weakSelf = self else { return }
            weakSelf.detectedFoods = allFoodModels
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                completion(allFoodModels.count > 0)
            })
        }
    }
}
