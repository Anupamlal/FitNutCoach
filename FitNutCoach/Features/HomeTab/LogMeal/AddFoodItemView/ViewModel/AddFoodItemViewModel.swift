//
//  AddFoodItemViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import UIKit

class AddFoodItemViewModel: ObservableObject {

    let selectedMealType: MealType
    
    init(selectedMealType: MealType) {
        self.selectedMealType = selectedMealType
    }
}
