//
//  Double+Extension.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI

extension Double {
    func intValue() -> Int {
        Int(self)
    }
    
    func formatToOneDecimalPlaces() -> String {
        let rounded = (self * 10).rounded() / 10
        return rounded.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(rounded))
            : String(rounded)
    }
}
