//
//  String+Extension.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/07/24.
//

import Foundation

extension String {
    
    func checkIfValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func checkIfValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,}$"
        
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: self)
    }
    
    func trimText() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func containsText(_ string: String) -> Bool {
        self.lowercased().contains(string.lowercased())
    }
    
    func getFirstName() -> String {
        let subArray = self.split(separator: " ")
        if let firstName = subArray.first {
            return String(firstName)
        }
        
        return self
    }
    
    func getEmailAsId() -> String {
        self.replacingOccurrences(of: ".", with: ",")
    }
    
    func getDateFromDateTime() -> Date? {
        return self.asDateFormattedWith("yyyy-MM-dd'T'HH:mm")
    }
    
    func getDateFromDate() -> Date? {
        return self.asDateFormattedWith("yyyy-MM-dd")
    }
    
    func asDateFormattedWith(_ format:String) -> Date? {
        let styler = DateFormatter()
        styler.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        styler.dateFormat = format
        styler.timeZone = TimeZone(identifier: "UTC")
        return styler.date(from: self)
    }
}
