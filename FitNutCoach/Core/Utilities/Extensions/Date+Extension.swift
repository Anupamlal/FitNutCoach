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
    
    func getUTCTime() -> String {
        self.getTime(timeZone: TimeZone(identifier: "UTC"))
    }
    
    func getTime(timeZone: TimeZone? = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}
