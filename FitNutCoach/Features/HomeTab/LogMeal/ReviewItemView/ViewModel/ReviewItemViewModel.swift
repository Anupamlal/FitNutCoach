//
//  ReviewItemViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 09/09/25.
//

import UIKit
import Combine
import CoreData

class ReviewItemViewModel: ObservableObject {

    @Published var reviewItem: FoodItemModel?
    @Published var isLoading: Bool = false
    @Published var imageUrl: String?
    @Published var numberOfServing: Int = 1
    @Published var servingSize: Double = 0
    @Published var totalCalories: Double = 0
    @Published var totalProtien: Double = 0
    @Published var totalCarbs: Double = 0
    @Published var totalFat: Double = 0
    
    private let sessionManager: URLSessionManager = URLSessionManager()
    private var cancellables: Set<AnyCancellable> = []
    private var foodCatalogManager: FoodCatalogManager?
    private var dailyActivityManager: DailyActivityManager?
    
    let mealType: MealType
    var barcode: String?
    
    init(barcode: String? = nil, mealType: MealType) {
        self.barcode = barcode
        self.mealType = mealType
    }
    
    private func fetchDetailsForBarcodeItem(barcode: String) async {
        
        print("fetchDetailsForBarcodeItem gets called")
        
        if let foodCatalogItem = await foodCatalogManager?.searchFoodWithBarcode(barcode) {
            doWorkAfterFetchingFoodCatalogItem(foodCatalogItem: foodCatalogItem)
            return
        }
        
        sessionManager.request(urlString: String(format: APIName.barcodeScannerAPI.rawValue, barcode))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                guard let weakSelf = self else { return }
                
                switch completion {
                case .failure(let err):
                    weakSelf.isLoading = false
                    print("GET failed:", err)
                case .finished:
                    print("GET finished")
                }
            } receiveValue: {[weak self] (barcodeModel: BarcodeModel) in
                
                guard let weakSelf = self else { return }

                let foodCatalogItem = FoodCatalogItemModel(barcodeModel: barcodeModel)
                
                Task {
                    await weakSelf.saveFoodCatalog(foodCatalogItem: foodCatalogItem)
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func saveFoodCatalog(foodCatalogItem: FoodCatalogItemModel) async {
        _ = await foodCatalogManager?.saveFoodCatalogItem(foodCatalogItem)

        doWorkAfterFetchingFoodCatalogItem(foodCatalogItem: foodCatalogItem)
    }
    
    private func doWorkAfterFetchingFoodCatalogItem(foodCatalogItem: FoodCatalogItemModel) {
        DispatchQueue.main.runInMainThread {
            self.isLoading = false
            self.reviewItem = FoodItemModel(foodCatalogItem: foodCatalogItem)
            self.imageUrl = foodCatalogItem.imageUrl
            self.updateMacrosForServing()
        }
    }
    
    func setUpFoodCatalogManager(foodCatalogManager: FoodCatalogManager, dailyActivityManager: DailyActivityManager) {
        self.foodCatalogManager = foodCatalogManager
        self.dailyActivityManager = dailyActivityManager
        
        if let barcode = self.barcode {
            self.isLoading = true
            
            Task {
                await fetchDetailsForBarcodeItem(barcode: barcode)
            }
        }
    }
    
    func updateMacrosForServing() {
        self.servingSize = (self.reviewItem?.servingSize ?? 0) * Double(numberOfServing)
        self.totalCalories = (self.reviewItem?.calories ?? 0) * Double(numberOfServing)
        self.totalCarbs = (self.reviewItem?.carbs ?? 0) * Double(numberOfServing)
        self.totalProtien = (self.reviewItem?.protein ?? 0) * Double(numberOfServing)
        self.totalFat = (self.reviewItem?.fat ?? 0) * Double(numberOfServing)
    }
    
    func fillUpdatedServingSizes() {
        self.reviewItem?.servingSize = self.servingSize
        self.reviewItem?.calories = self.totalCalories
        self.reviewItem?.carbs = self.totalCarbs
        self.reviewItem?.protein = self.totalProtien
        self.reviewItem?.fat = self.totalFat
    }
    
    func confirmFoodAndUpdate() async -> Bool {
        
        guard let foodItem = self.reviewItem else {
            return false
        }
        
        guard let viewContext = foodCatalogManager?.viewContext else {
            return false
        }
        
        var mealSourceType: MealSourceType = .photo
        
        if self.barcode != nil {
            mealSourceType = .barcode
        }
        
        var currentMeal = await MealManager.getMealFor(date: Date(), mealType: self.mealType, viewContext: viewContext)
            
        if currentMeal == nil {
            currentMeal = MealModel(id: UUID().uuidString, aiConfidence: 1, createdAt: Date(), date: Date(), mealType: self.mealType, notes: nil, photoId: nil, mealSource: mealSourceType, updatedAt: Date(), foodItems: [foodItem])
            
        }else {
            currentMeal?.updatedAt = Date()
            currentMeal?.foodItems?.append(foodItem)
        }
        
        return await dailyActivityManager?.addMeal(currentMeal!) ?? false
    }
}
