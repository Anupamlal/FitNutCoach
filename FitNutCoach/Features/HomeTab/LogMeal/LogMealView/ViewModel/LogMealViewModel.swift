//
//  LogMealViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import UIKit
import Combine

class LogMealViewModel: ObservableObject {

    @Published var openAddFoodView: (Bool, MealType?) = (false, .breakfast)
    @Published var dailyTotalCalories: Double = 0
    @Published var dailyActivityModel: DailyActivityModel?
    
    private var dailyActivityManager: DailyActivityManager?
    private var profileManager: ProfileManager?
    private var cancellable = Set<AnyCancellable>()
    
    func setDailyActivityManager(_ dailyActivityManager: DailyActivityManager?, _ profileManager: ProfileManager?) {
        self.dailyActivityManager = dailyActivityManager
        self.profileManager = profileManager
        loadData()
    }
    
    private func loadData() {
        Task {
            await self.profileManager?.loadData()
            await self.dailyActivityManager?.loadTodayData()
        }
        
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
