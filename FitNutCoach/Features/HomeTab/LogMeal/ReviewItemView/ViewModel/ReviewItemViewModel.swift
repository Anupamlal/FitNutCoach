//
//  ReviewItemViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 09/09/25.
//

import UIKit
import Combine

class ReviewItemViewModel: ObservableObject {

    @Published var reviewItem: FoodCatalogItemModel?
    @Published var isLoading: Bool = false
    
    private let sessionManager: URLSessionManager = URLSessionManager()
    private var cancellables: Set<AnyCancellable> = []
    private var foodCatalogManager: FoodCatalogManager?
    var barcode: String?
    
    init(barcode: String? = nil) {
        self.barcode = barcode
    }
    
    func setUpFoodCatalogManager(foodCatalogManager: FoodCatalogManager) {
        self.foodCatalogManager = foodCatalogManager
        
        if let barcode = self.barcode {
            self.isLoading = true
            
            Task {
                await fetchDetailsForBarcodeItem(barcode: barcode)
            }
        }
    }
    
    private func fetchDetailsForBarcodeItem(barcode: String) async {
        
        print("fetchDetailsForBarcodeItem gets called")
        
        if let foodCatalogItem = await foodCatalogManager?.searchFoodWithBarcode(barcode) {
            DispatchQueue.main.runInMainThread {
                self.isLoading = false
                self.reviewItem = foodCatalogItem
            }
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

        DispatchQueue.main.runInMainThread {
            self.isLoading = false
            self.reviewItem = foodCatalogItem
        }
    }
}
