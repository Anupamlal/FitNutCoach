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
    @Published var openGallery: Bool = false
    @Published var photoPickerItem: PhotosPickerItem?
    @Published var openImageDetectionFlow: Bool = false

    var selectedImage: UIImage?
    
    private var dailyActivityManager: DailyActivityManager?
    private var profileManager: ProfileManager?
    private var cancellable = Set<AnyCancellable>()
    
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
    
}
