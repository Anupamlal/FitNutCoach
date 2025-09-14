//
//  AddFoodItemViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import UIKit
import Combine

enum AddFoodSectionType {
    case history
    case frequentlyUsed
}

class AddFoodItemViewModel: ObservableObject {

    let selectedMealType: MealType
    @Published var openBarCodeScanner: Bool = false
    @Published var searchText: String = ""{
        didSet {
            setUpFoodCatalogUsingSearchText()
        }
    }
    @Published var selectedFoods = [FoodItemModel]()
    @Published var addFoodSections: [AddFoodSectionType] = [.history, .frequentlyUsed]
    @Published var filteredHistoryFoods: [FoodItemModel] = []
    @Published var filteredFrequentlyUsedFoods: [FoodItemModel] = []
    
    private var historyFoodItems: [FoodItemModel] = []
    private var frequentlyUsedFoodItems: [FoodItemModel] = []

    private var foodCatalogManager: FoodCatalogManager?
    private var dailyActivityManager: DailyActivityManager?
    private var cancellables: Set<AnyCancellable> = []
    
    init(selectedMealType: MealType) {
        self.selectedMealType = selectedMealType
    }
    
    func setup(_ foodCatalogManager: FoodCatalogManager, _ dailyActivityManager: DailyActivityManager) {
        self.foodCatalogManager = foodCatalogManager
        self.dailyActivityManager = dailyActivityManager
        fetchAllFoodItems()
    }
    
    private func fetchAllFoodItems() {
        guard let foodCatalogManager = foodCatalogManager else { return }
        
        Task {
            await foodCatalogManager.loadData()
        }
        
        self.foodCatalogManager?.foodCatalogPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] allFoodCatalogs in
                self?.frequentlyUsedFoodItems = allFoodCatalogs.map{FoodItemModel(foodCatalogItem: $0)}
                self?.setUpFoodCatalogUsingSearchText()
            }
            .store(in: &cancellables)
        
    }
    
    func setUpFoodCatalogUsingSearchText() {
        guard searchText.isEmpty == false else {
            self.addFoodSections = [.history, .frequentlyUsed]
            self.filteredHistoryFoods = self.historyFoodItems
            self.filteredFrequentlyUsedFoods = self.frequentlyUsedFoodItems
            return
        }
        
        let historyFoodItems = self.historyFoodItems.filter{$0.name?.localizedCaseInsensitiveContains(searchText) ?? false}
        let frequentlyUsedFoodItems = self.frequentlyUsedFoodItems.filter{$0.name?.localizedCaseInsensitiveContains(searchText) ?? false}
        
        self.addFoodSections = []
        if historyFoodItems.count > 0{
            self.addFoodSections.append(.history)
            self.filteredHistoryFoods = historyFoodItems
        }
        
        if frequentlyUsedFoodItems.count > 0{
            self.addFoodSections.append(.frequentlyUsed)
            self.filteredFrequentlyUsedFoods = frequentlyUsedFoodItems
        }
    }
    
    func logSelectedFood() async -> Bool {
    
        guard let viewContext = foodCatalogManager?.viewContext else {
            return false
        }
        
        var mealSourceType: MealSourceType = searchText.isEmpty ? .manual : .search
        
        var currentMeal = await MealManager.getMealFor(date: Date(), mealType: self.selectedMealType, viewContext: viewContext)
        
        if currentMeal == nil {
            currentMeal = MealModel(id: UUID().uuidString, aiConfidence: 1, createdAt: Date(), date: Date(), mealType: self.selectedMealType, notes: nil, photoId: nil, mealSource: mealSourceType, updatedAt: Date(), foodItems: self.selectedFoods)
            
        }else {
            currentMeal?.updatedAt = Date()
            
            if var foodItems = currentMeal?.foodItems{
                foodItems += self.selectedFoods
                currentMeal?.foodItems = foodItems
                
            }else {
                currentMeal?.foodItems = self.selectedFoods
            }
            
        }
        
        return await dailyActivityManager?.addMeal(currentMeal!) ?? false
    }
    
}
