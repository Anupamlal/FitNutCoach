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
    @Published var currentMealType: MealType = .breakfast
    @Published var openMealTypeSelection: Bool = false
    private var dailyActivityManager: DailyActivityManager?
    
    var selectedFoodItems: [FoodItemModel] = [] {
        didSet {
            shouldShowConfirmButton = !selectedFoodItems.isEmpty
        }
    }
    
    init(selectedItemImage: UIImage, detectedFoodItems: [FoodItemModel]) {
        self.selectedItemImage = selectedItemImage
        self.detectedFoodItems = detectedFoodItems
        setCurrentMealType()
    }
    
    func setup(_ dailyActivityManager: DailyActivityManager) {
        self.dailyActivityManager = dailyActivityManager
    }
    
    private func setCurrentMealType() {
        self.currentMealType = getCurrentMealType()
    }
    
    func logSelectedFood() async -> Bool {
    
        guard let viewContext = dailyActivityManager?.viewContext else {
            return false
        }
        
        let mealSourceType: MealSourceType = .photo
        
        var currentMeal = await MealManager.getMealFor(date: Date(), mealType: self.currentMealType, viewContext: viewContext)
        
        if currentMeal == nil {
            currentMeal = MealModel(id: UUID().uuidString, aiConfidence: 1, createdAt: Date(), date: Date().getStartOfDate(), mealType: self.currentMealType, notes: nil, photoId: nil, mealSource: mealSourceType, updatedAt: Date(), foodItems: self.selectedFoodItems)
            
        }else {
            currentMeal?.updatedAt = Date()
            
            if var foodItems = currentMeal?.foodItems{
                foodItems += self.selectedFoodItems
                currentMeal?.foodItems = foodItems
                
            }else {
                currentMeal?.foodItems = self.selectedFoodItems
            }
            
        }
        
        return await dailyActivityManager?.addMeal(currentMeal!) ?? false
    }
    
    private func getCurrentMealType() -> MealType {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        switch currentHour {
        case 5..<11:
            return .breakfast
        case 11..<16:
            return .lunch
        case 16..<21:
            return .dinner
        default:
            return .snacks
        }
    }
}
