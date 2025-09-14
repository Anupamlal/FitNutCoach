//
//  LogMealViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import UIKit

class LogMealViewModel: ObservableObject {

    @Published var openAddFoodView: (Bool, MealType?) = (false, .breakfast)
}
