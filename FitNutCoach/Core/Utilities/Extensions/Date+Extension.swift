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
    
    func getDayName(timeZone: TimeZone? = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
