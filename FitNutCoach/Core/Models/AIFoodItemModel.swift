//
//  AIFoodItemModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import UIKit

struct AIFoodItemModel: Codable {
    var id = UUID().uuidString
    let name: String
    let crb: Double
    let ptn: Double
    let fat: Double
    let clry: Double
    let quantity: Double
    let mUnit: String?
    let cnfdnc: Double
    var foodSource: MealSourceType = .photo
}
