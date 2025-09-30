//
//  Date+Extension.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import SwiftUI

extension Date {
    func getStartOfDate() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func getDayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }
}
