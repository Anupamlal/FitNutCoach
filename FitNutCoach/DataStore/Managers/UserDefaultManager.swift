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
    
    class func saveProfileSetupDone(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: profileSetupDone)
    }
    
    class func isProfileSetupDone() -> Bool {
        return UserDefaults.standard.bool(forKey: profileSetupDone)
    }
}
