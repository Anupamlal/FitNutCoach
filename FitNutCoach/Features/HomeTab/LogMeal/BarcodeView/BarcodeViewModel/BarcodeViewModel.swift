//
//  BarcodeViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 07/09/25.
//

import UIKit

class BarcodeViewModel: ObservableObject {

    @Published var isBarcodeDetected = false
    @Published var barcodeValue: String = ""
    @Published var isSessionRunning: Bool = true
    @Published var isManualEntryOpen: Bool = false
}
