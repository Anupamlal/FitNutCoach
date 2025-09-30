//
//  LogMealViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import SwiftUI
import Combine
import PhotosUI

class LogMealViewModel: ObservableObject {

    @Published var dailyTotalCalories: Double = 0
    @Published var dailyActivityModel: DailyActivityModel?
    @Published var openBottomSheetForImageSelection: Bool = false
    @Published var openImageSelectionView: Bool = false
    @Published var openImageDetectionFlow: Bool = false
    @Published var showMenuOptions: (Bool, FoodItemModel?, MealType?) = (false, nil, nil)

    var selectedImage: UIImage?
    var imageSelectionType: PictureSelectorType = .camera
    
    private var dailyActivityManager: DailyActivityManager?
    private var profileManager: ProfileManager?
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        self.dailyActivityModel = nil
        self.dailyActivityManager = nil
        self.profileManager = nil
        self.cancellable.removeAll()
        self.cancellable = []
        self.selectedImage = nil
        
        print("LogMealViewModel deinit")
    }
    
    func setDailyActivityManager(_ dailyActivityManager: DailyActivityManager?, _ profileManager: ProfileManager?) {
        self.dailyActivityManager = dailyActivityManager
        self.profileManager = profileManager
        loadData()
    }
    
    private func loadData() {
        self.profileManager?.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] profileModel in
                self?.dailyTotalCalories = profileModel.calorieTarget
            }
            .store(in: &cancellable)
        
        self.dailyActivityManager?.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] dailyActivityModel in
                self?.dailyActivityModel = dailyActivityModel
            }
            .store(in: &cancellable)
    }
    
    func getFoodItemsFor(mealType: MealType) -> [FoodItemModel] {
        guard let dailyActivityModel = self.dailyActivityModel, let meals = dailyActivityModel.meals else {
            return []
        }
        
        return meals.first(where: { $0.mealType == mealType})?.foodItems ?? []
    }
    
    func deleteFoodItem(foodItemModel: FoodItemModel, mealType: MealType) async -> Bool {
        guard let dailyActivityManager = dailyActivityManager else {
            return false
        }
        
        return await dailyActivityManager.deleteFoodItem(date: Date(), foodItem: foodItemModel, mealType: mealType)
    }
    
}
