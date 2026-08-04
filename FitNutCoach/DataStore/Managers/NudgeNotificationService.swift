//
//  NudgeNotificationService.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 04/08/26.
//

import UserNotifications

struct NudgeNotificationPreferences {
    var isEnabled: Bool
    var quietHoursStart: Int
    var quietHoursEnd: Int
    var maxNotificationsPerDay: Int
    
    static var `default`: NudgeNotificationPreferences {
        NudgeNotificationPreferences(
            isEnabled: true,
            quietHoursStart: 22,
            quietHoursEnd: 7,
            maxNotificationsPerDay: 3
        )
    }
}

final class NudgeNotificationService {
    
    static let shared = NudgeNotificationService()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorizationIfNeeded() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func scheduleNotifications(for nudges: [NudgeModel]) {
        let preferences = UserDefaultManager.getNudgeNotificationPreferences()
        guard preferences.isEnabled else {
            clearNudgeNotifications()
            return
        }
        
        let hour = Calendar.current.component(.hour, from: Date())
        if isQuietHour(hour: hour, preferences: preferences) {
            return
        }
        
        clearNudgeNotifications()
        
        let eligibleNudges = nudges
            .filter { $0.isVisible && $0.priority == .high }
            .sorted { $0.priority > $1.priority }
            .prefix(preferences.maxNotificationsPerDay)
        
        for nudge in eligibleNudges {
            scheduleNotification(for: nudge)
        }
    }
    
    private func scheduleNotification(for nudge: NudgeModel) {
        let content = UNMutableNotificationContent()
        content.title = nudge.title
        content.body = nudge.message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(
            identifier: "nudge_\(nudge.ruleId)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
    
    private func clearNudgeNotifications() {
        notificationCenter.getPendingNotificationRequests { requests in
            let nudgeIds = requests
                .map(\.identifier)
                .filter { $0.hasPrefix("nudge_") }
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: nudgeIds)
        }
    }
    
    private func isQuietHour(hour: Int, preferences: NudgeNotificationPreferences) -> Bool {
        if preferences.quietHoursStart < preferences.quietHoursEnd {
            return hour >= preferences.quietHoursStart && hour < preferences.quietHoursEnd
        }
        return hour >= preferences.quietHoursStart || hour < preferences.quietHoursEnd
    }
}
