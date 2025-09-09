//
//  ReviewItemViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 09/09/25.
//

import UIKit
import Combine

class ReviewItemViewModel: ObservableObject {

    @Published var reviewItem: FoodCatalogItem?
    @Published var isLoading: Bool = false
    
    private let sessionManager: URLSessionManager = URLSessionManager()
    private var cancellables: Set<AnyCancellable> = []
    var barcode: String?
    
    
    init(barcode: String? = nil) {
        self.barcode = barcode
    }
    
    func fetchDetailsForBarcodeItem() {
        guard let barcode = barcode else { return }
        DispatchQueue.main.async { [self] in
            isLoading = true
        }
        
        sessionManager.request(urlString: String(format: APIName.barcodeScannerAPI.rawValue, barcode))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                
                guard let weakSelf = self else { return }
                weakSelf.isLoading = false
                
                switch completion {
                case .failure(let err):
                    print("GET failed:", err)
                case .finished:
                    print("GET finished")
                }
            } receiveValue: { (barcodeModel: BarcodeModel) in
                self.reviewItem = FoodCatalogItem(barcodeModel: barcodeModel)
            }
            .store(in: &cancellables)
        
    }
}
