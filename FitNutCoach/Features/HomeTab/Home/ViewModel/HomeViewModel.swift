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
    @Published var currentWeatherInfo: String? = nil
    @Published var primaryNudge: NudgeModel?
    @Published var nudgePreviewText: String = ""
    
    private let profileManager: ProfileManager
    private let dailyActivityManager: DailyActivityManager
    private let nudgeManager: NudgeManager
    private var cancellable = Set<AnyCancellable>()
    private var currentWeatherModel = WeatherModel()
    let weatherManager: WeatherManager
    
    init(
        profileManager: ProfileManager,
        dailyActivityManager: DailyActivityManager,
        nudgeManager: NudgeManager
    ) {
        self.profileManager = profileManager
        self.dailyActivityManager = dailyActivityManager
        self.nudgeManager = nudgeManager
        weatherManager = .init(container: PersistenceController.shared.container)
    }
    
    deinit {
        self.cancellable.removeAll()
    }
    
    func onAppear(foodCatalogManager: FoodCatalogManager) {
        NudgeNotificationService.shared.requestAuthorizationIfNeeded()
        
        Task {
            async let profileManagerLoaded = self.profileManager.loadData()
            async let dailyActivityManagerLoaded = self.dailyActivityManager.loadTodayData()
            async let foodCatalogLoadedFromServer = foodCatalogManager.loadAllFoodCatalogFromServer()
            async let weatherDataLoaded = self.weatherManager.setup()
            async let nudgesLoaded = self.nudgeManager.loadData()
            
            let allProcessDone = await [
                profileManagerLoaded,
                dailyActivityManagerLoaded,
                foodCatalogLoadedFromServer,
                weatherDataLoaded,
                nudgesLoaded
            ]
            
            print("All Process Done \(allProcessDone)")
            _ = await foodCatalogManager.loadData()
            await syncNudges()
        }
        
        self.profileManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] profileModel in
                self?.profileModel = profileModel
                Task { await self?.syncNudges() }
            }
            .store(in: &cancellable)
        
        self.dailyActivityManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] dailyActivityModel in
                self?.dailyActivityModel = dailyActivityModel
                self?.numberOfWorkoutDays = dailyActivityModel.workouts?.count ?? 0
                Task { await self?.syncNudges() }
            }
            .store(in: &cancellable)
        
        self.weatherManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] currentWeather in
                if currentWeather.cityName != nil {
                    self?.currentWeatherModel = currentWeather
                    self?.currentWeatherInfo = "\(currentWeather.weatherCondition.getIcon()) \(currentWeather.temperature) \(currentWeather.weatherCondition.getName())"
                    Task { await self?.syncNudges() }
                }
            }
            .store(in: &cancellable)
        
        self.nudgeManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] nudges in
                self?.updateNudgePreview(from: nudges)
            }
            .store(in: &cancellable)
    }
    
    func getDailyActivityManager() -> DailyActivityManager {
        return self.dailyActivityManager
    }
    
    func getNudgeManager() -> NudgeManager {
        return self.nudgeManager
    }
    
    func checkWeatherUpdateOnActive() {
        self.weatherManager.checkIfWeatherDataIsStale()
        Task { await syncNudges() }
    }
    
    func handlePrimaryNudgeAction(
        homeNavRouter: Router<HomeRouter>,
        rootTabViewModel: RootTabViewModel
    ) {
        guard let nudge = primaryNudge else { return }
        
        switch nudge.actionType {
        case .openWaterTracker:
            openWaterIntakeView = true
        case .openFoodLogger:
            homeNavRouter.navigate(to: .logMeal)
            homeNavRouter.navigate(to: .addFoodItem(selectedMealType: .suggestedForCurrentTime()))
        case .openMealLog:
            let mealType = MealType(rawValue: nudge.actionValue ?? "") ?? .suggestedForCurrentTime()
            homeNavRouter.navigate(to: .logMeal)
            homeNavRouter.navigate(to: .addFoodItem(selectedMealType: mealType))
        case .openActivity:
            rootTabViewModel.currentTab = .trends
        case .openWeight:
            rootTabViewModel.currentTab = .profile
        case .openWorkout:
            rootTabViewModel.currentTab = .workouts
        case .viewDetails, .none:
            homeNavRouter.navigate(to: .allNudges)
        }
    }
    
    private func syncNudges() async {
        await nudgeManager.syncNudges(
            profile: profileModel,
            dailyActivity: dailyActivityModel,
            weather: currentWeatherModel.cityName != nil ? currentWeatherModel : nil
        )
    }
    
    private func updateNudgePreview(from nudges: [NudgeModel]) {
        let active = nudges.filter(\.isVisible)
        primaryNudge = active.first
        nudgePreviewText = primaryNudge?.message ?? AppTexts.nudgeNoActiveText
    }
}
