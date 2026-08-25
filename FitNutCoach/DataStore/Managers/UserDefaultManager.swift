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
    static let workoutSetupDone = "workoutSetupDone"
    static let aiDetectionLeftCount = "AIDetectionLeftCount"
    
    static let nudgeNotificationsEnabled = "nudgeNotificationsEnabled"
    static let nudgeQuietHoursStart = "nudgeQuietHoursStart"
    static let nudgeQuietHoursEnd = "nudgeQuietHoursEnd"
    static let nudgeMaxNotificationsPerDay = "nudgeMaxNotificationsPerDay"
    
    class func saveProfileSetupDone(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: profileSetupDone)
    }
    
    class func isProfileSetupDone() -> Bool {
        return UserDefaults.standard.bool(forKey: profileSetupDone)
    }

    class func saveWorkoutSetupDone(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: workoutSetupDone)
    }

    class func isWorkoutSetupDone() -> Bool {
        return UserDefaults.standard.bool(forKey: workoutSetupDone)
    }
    
    class func saveAIDetectionLeftCount(_ count: Int) {
        UserDefaults.standard.set(count, forKey: aiDetectionLeftCount)
    }
    
    class func getAIDetectionLeftCount() -> Int {
        return UserDefaults.standard.integer(forKey: aiDetectionLeftCount)
    }
    
    class func getNudgeNotificationPreferences() -> NudgeNotificationPreferences {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: nudgeNotificationsEnabled) == nil {
            return .default
        }
        return NudgeNotificationPreferences(
            isEnabled: defaults.bool(forKey: nudgeNotificationsEnabled),
            quietHoursStart: defaults.integer(forKey: nudgeQuietHoursStart),
            quietHoursEnd: defaults.integer(forKey: nudgeQuietHoursEnd),
            maxNotificationsPerDay: max(1, defaults.integer(forKey: nudgeMaxNotificationsPerDay))
        )
    }
    
    class func saveNudgeNotificationPreferences(_ preferences: NudgeNotificationPreferences) {
        let defaults = UserDefaults.standard
        defaults.set(preferences.isEnabled, forKey: nudgeNotificationsEnabled)
        defaults.set(preferences.quietHoursStart, forKey: nudgeQuietHoursStart)
        defaults.set(preferences.quietHoursEnd, forKey: nudgeQuietHoursEnd)
        defaults.set(preferences.maxNotificationsPerDay, forKey: nudgeMaxNotificationsPerDay)
    }
}
