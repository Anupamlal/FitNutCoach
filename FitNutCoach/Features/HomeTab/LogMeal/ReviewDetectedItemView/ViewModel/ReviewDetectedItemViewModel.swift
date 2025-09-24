//
//  ReviewDetectedItemViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import UIKit

class ReviewDetectedItemViewModel: ObservableObject {

    let selectedItemImage: UIImage
    @Published var detectedFoodItems: [FoodItemModel]
    @Published var shouldShowConfirmButton: Bool = false
    
    var selectedFoodItems: [FoodItemModel] = [] {
        didSet {
            shouldShowConfirmButton = !selectedFoodItems.isEmpty
        }
    }
    
    init(selectedItemImage: UIImage, detectedFoodItems: [FoodItemModel]) {
        self.selectedItemImage = selectedItemImage
        self.detectedFoodItems = detectedFoodItems
    }
    
}
