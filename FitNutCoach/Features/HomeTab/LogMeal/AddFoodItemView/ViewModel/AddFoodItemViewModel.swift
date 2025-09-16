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
            setUpFoodItemsUsingSearchText()
        }
    }
    @Published var selectedFoods = [FoodItemModel]()
    @Published var addFoodSections: [AddFoodSectionType] = [.history, .frequentlyUsed]
    @Published var filteredHistoryFoods: [FoodItemModel] = []
    @Published var filteredFrequentlyUsedFoods: [FoodItemModel] = []
    
    private var historyFoodItems: [FoodItemModel] = []
    private var frequentlyUsedFoodItems: [FoodItemModel] = []
    private var dailyActivityManager: DailyActivityManager?
    private var foodHistoryManager: FoodHistoryManager?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(selectedMealType: MealType) {
        self.selectedMealType = selectedMealType
    }
    
    func setup(_ dailyActivityManager: DailyActivityManager) {
        self.dailyActivityManager = dailyActivityManager
        fetchAllFoodItems()
    }
    
    private func fetchAllFoodItems() {
        guard let viewContext = dailyActivityManager?.viewContext else {
            return
        }
        
        self.foodHistoryManager = FoodHistoryManager(context: viewContext)
        
        self.foodHistoryManager?.foodHistoryPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let _ = self else {return}
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] (historyFoodItems, frequentFoodItems) in
                
                guard let weakSelf = self else {return}
                
                weakSelf.historyFoodItems = historyFoodItems
                weakSelf.frequentlyUsedFoodItems = frequentFoodItems
                weakSelf.setUpFoodItemsUsingSearchText()
            })
            .store(in: &cancellables)
        
    }
    
    func setUpFoodItemsUsingSearchText() {
        guard searchText.isEmpty == false else {
            self.addFoodSections = []
            if self.historyFoodItems.count > 0 {
                self.addFoodSections.append(.history)
                self.filteredHistoryFoods = self.historyFoodItems
            }
            
            if self.frequentlyUsedFoodItems.count > 0 {
                self.addFoodSections.append(.frequentlyUsed)
                self.filteredFrequentlyUsedFoods = self.frequentlyUsedFoodItems
            }
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
    
        guard let viewContext = dailyActivityManager?.viewContext else {
            return false
        }
        
        let mealSourceType: MealSourceType = searchText.isEmpty ? .manual : .search
        
        var currentMeal = await MealManager.getMealFor(date: Date(), mealType: self.selectedMealType, viewContext: viewContext)
        
        if currentMeal == nil {
            currentMeal = MealModel(id: UUID().uuidString, aiConfidence: 1, createdAt: Date(), date: Date().getStartOfDate(), mealType: self.selectedMealType, notes: nil, photoId: nil, mealSource: mealSourceType, updatedAt: Date(), foodItems: self.selectedFoods)
            
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
