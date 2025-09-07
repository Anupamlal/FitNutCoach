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
    @Published var openLogMealView = false
    @Published var openLogWorkoutView = false
    
    @Published var openBarcodeScanner = false
    @Published var openCameraScanner = false
    @Published var openManualEntry = false
    
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
    
    func onAppear() {
        Task {
            await self.profileManager.loadData()
            await self.dailyActivityManager.loadTodayData()
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
    
    func setLogMealOption(selectedOption: MealSourceType) {
        self.openBarcodeScanner = false
        self.openManualEntry = false
        self.openCameraScanner = false
        
        switch selectedOption {
        case .barcode:
            self.openBarcodeScanner = true
        case .manual:
            self.openManualEntry = true
        case .photo:
            self.openCameraScanner = true
        }
    }
}
