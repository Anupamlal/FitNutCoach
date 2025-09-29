//
//  UserDefaultManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 11/09/25.
//

import UIKit

class UserDefaultManager {

    static let isNewUser = "isNewUser"
    static let profileSetupDone = "profileSetupDone"
    static let aiDetectionLeftCount = "AIDetectionLeftCount"
    
    class func saveProfileSetupDone(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: profileSetupDone)
    }
    
    class func isProfileSetupDone() -> Bool {
        return UserDefaults.standard.bool(forKey: profileSetupDone)
    }
    
    class func saveAIDetectionLeftCount(_ count: Int) {
        UserDefaults.standard.set(count, forKey: aiDetectionLeftCount)
    }
    
    class func getAIDetectionLeftCount() -> Int {
        return UserDefaults.standard.integer(forKey: aiDetectionLeftCount)
    }
}
