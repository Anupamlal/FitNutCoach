//
//  AppColors.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

class AppColors {
    
    static let calorieProgressColor: Color = Color(hex: 0xEF4444)
    static let calorieTotalColor: Color = Color(hex: 0xFEE2E2)
    static let calorieOverTargetColor: Color = Color(hex: 0xF97316)
    
    static let stepsProgressColor: Color = Color(hex: 0x22C55E)
    static let stepsTotalColor: Color = Color(hex: 0xDCFCE7)
    static let stepsOverTargetColor: Color = Color(hex: 0x15803D)
    
    static let waterProgressColor: Color = Color(hex: 0x0EA5E9)
    static let waterTotalColor: Color = Color(hex: 0xDBEAFE)
    static let waterOverTargetColor: Color = Color(hex: 0x22C55E)
    
    static let barcodeReaderColor: Color = Color(hex: 0xF59E0B)
    static let manualReaderColor: Color = Color(hex: 0x10B981)
    
    static let foodCardBGColor: Color = Color(hex: 0xF3F4F6)
    static let protienColor: Color = Color(hex: 0x3B82F6)
    static let carbsColor: Color = Color(hex: 0xFACC15)
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
