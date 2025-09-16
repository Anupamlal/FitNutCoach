//
//  HomeViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {

    @Published var profileModel = ProfileModel()
    @Published var dailyActivityModel = DailyActivityModel()
    @Published var numberOfWorkoutDays = 3
    @Published var openWaterIntakeView = false
    @Published var openLogWorkoutView = false
    
    private let profileManager: ProfileManager
    private let dailyActivityManager: DailyActivityManager
    private var cancellable = Set<AnyCancellable>()
    
    init(profileManager: ProfileManager, dailyActivityManager: DailyActivityManager) {
        self.profileManager = profileManager
        self.dailyActivityManager = dailyActivityManager
    }
    
    deinit {
        self.cancellable.removeAll()
    }
    
    func onAppear(foodCatalogManager: FoodCatalogManager) {
        Task {
            async let profileManagerLoaded = self.profileManager.loadData()
            async let dailyActivityManagerLoaded = self.dailyActivityManager.loadTodayData()
            async let foodCatalogLoadedFromServer = foodCatalogManager.loadAllFoodCatalogFromServer()
            
            let allProcessDone = await [profileManagerLoaded, dailyActivityManagerLoaded, foodCatalogLoadedFromServer]
            
            print("All Process Done \(allProcessDone)")
            _ = await foodCatalogManager.loadData()
        }
        
        self.profileManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] profileModel in
                self?.profileModel = profileModel
            }
            .store(in: &cancellable)
        
        self.dailyActivityManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] dailyActivityModel in
                self?.dailyActivityModel = dailyActivityModel
                self?.numberOfWorkoutDays = dailyActivityModel.workouts?.count ?? 0
            }
            .store(in: &cancellable)
    }
    
    func getDailyActivityManager() -> DailyActivityManager {
        return self.dailyActivityManager
    }
}
