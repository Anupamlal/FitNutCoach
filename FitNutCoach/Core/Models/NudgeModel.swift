//
//  NudgeModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 16/10/25.
//

import UIKit

enum NudgeCategory: String, Codable, CaseIterable {
    case hydration
    case nutrition
    case activity
    case workout
    case sleep
    case weight
    case weather
    case recovery
    case mealLogging
    case achievement
    
    func displayName() -> String {
        switch self {
        case .hydration: return AppTexts.nudgeCategoryHydrationText
        case .nutrition: return AppTexts.nudgeCategoryNutritionText
        case .activity: return AppTexts.nudgeCategoryActivityText
        case .workout: return AppTexts.nudgeCategoryWorkoutText
        case .sleep: return AppTexts.nudgeCategorySleepText
        case .weight: return AppTexts.nudgeCategoryWeightText
        case .weather: return AppTexts.nudgeCategoryWeatherText
        case .recovery: return AppTexts.nudgeCategoryRecoveryText
        case .mealLogging: return AppTexts.nudgeCategoryMealLoggingText
        case .achievement: return AppTexts.nudgeCategoryAchievementText
        }
    }
    
    func iconEmoji() -> String {
        switch self {
        case .hydration: return "💧"
        case .nutrition: return "🥗"
        case .activity: return "🚶"
        case .workout: return "🏋️"
        case .sleep: return "🌙"
        case .weight: return "⚖️"
        case .weather: return "🌤️"
        case .recovery: return "🧘"
        case .mealLogging: return "🍽️"
        case .achievement: return "🏆"
        }
    }
}

enum NudgePriority: Int16, Codable, CaseIterable, Comparable {
    case low = 1
    case medium = 2
    case high = 3
    
    static func < (lhs: NudgePriority, rhs: NudgePriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    func displayName() -> String {
        switch self {
        case .high: return AppTexts.nudgePriorityHighText
        case .medium: return AppTexts.nudgePriorityMediumText
        case .low: return AppTexts.nudgePriorityLowText
        }
    }
    
    var color: UIColor {
        switch self {
        case .high: return UIColor.systemRed
        case .medium: return UIColor.systemOrange
        case .low: return UIColor.systemBlue
        }
    }
}

enum NudgeStatus: String, Codable {
    case active
    case completed
    case dismissed
    case expired
    
    static func fromStoredValue(_ raw: String?) -> NudgeStatus {
        switch raw {
        case "done":
            return .completed
        case "snoozed":
            return .active
        default:
            return NudgeStatus(rawValue: raw ?? "") ?? .active
        }
    }
}

enum NudgeActionType: String, Codable {
    case none
    case openWaterTracker
    case openFoodLogger
    case openActivity
    case openWeight
    case openWorkout
    case openMealLog
    case viewDetails
    
    func actionButtonTitle() -> String? {
        switch self {
        case .none, .viewDetails:
            return nil
        case .openWaterTracker:
            return AppTexts.nudgeActionDrinkWaterText
        case .openFoodLogger:
            return AppTexts.nudgeActionEatProteinText
        case .openActivity:
            return AppTexts.nudgeActionWalkMoreText
        case .openWeight:
            return AppTexts.nudgeActionLogWeightText
        case .openWorkout:
            return AppTexts.nudgeActionStartWorkoutText
        case .openMealLog:
            return AppTexts.nudgeActionLogMealText
        }
    }
}

struct NudgeModel: Codable, Identifiable, Hashable {
    let id: String
    let ruleId: String
    let title: String
    let message: String
    let category: NudgeCategory
    let priority: NudgePriority
    var status: NudgeStatus
    let createdAt: Date
    let date: Date
    let expiresAt: Date?
    let actionType: NudgeActionType
    let actionValue: String?
    var completedAt: Date?
    var snoozedUntil: Date?
    
    init(
        id: String = UUID().uuidString,
        ruleId: String,
        title: String,
        message: String,
        category: NudgeCategory,
        priority: NudgePriority,
        status: NudgeStatus = .active,
        createdAt: Date = Date(),
        date: Date = Date().getStartOfDate(),
        expiresAt: Date? = nil,
        actionType: NudgeActionType = .none,
        actionValue: String? = nil,
        completedAt: Date? = nil,
        snoozedUntil: Date? = nil
    ) {
        self.id = id
        self.ruleId = ruleId
        self.title = title
        self.message = message
        self.category = category
        self.priority = priority
        self.status = status
        self.createdAt = createdAt
        self.date = date.getStartOfDate()
        self.expiresAt = expiresAt
        self.actionType = actionType
        self.actionValue = actionValue
        self.completedAt = completedAt
        self.snoozedUntil = snoozedUntil
    }
    
    init(with nudge: Nudge) {
        self.id = nudge.id ?? UUID().uuidString
        self.ruleId = nudge.ruleId ?? nudge.id ?? UUID().uuidString
        self.title = nudge.title ?? ""
        self.message = nudge.message ?? ""
        
        if let categoryRaw = nudge.category, let category = NudgeCategory(rawValue: categoryRaw) {
            self.category = category
        } else if let legacyType = nudge.type, let category = NudgeCategory(rawValue: legacyType) {
            self.category = category
        } else {
            self.category = .hydration
        }
        
        self.priority = NudgePriority(rawValue: nudge.priority) ?? .medium
        self.status = NudgeStatus.fromStoredValue(nudge.state)
        self.createdAt = nudge.createdAt ?? Date()
        self.date = nudge.date ?? nudge.createdAt?.getStartOfDate() ?? Date().getStartOfDate()
        self.expiresAt = nudge.expiresAt
        self.actionType = NudgeActionType(rawValue: nudge.actionType ?? "") ?? .none
        self.actionValue = nudge.actionValue
        self.completedAt = nudge.completedAt
        self.snoozedUntil = nudge.snoozedUntil
    }
    
    func fill(into nudge: Nudge) {
        nudge.id = id
        nudge.ruleId = ruleId
        nudge.title = title
        nudge.message = message
        nudge.category = category.rawValue
        nudge.type = category.rawValue
        nudge.icon = category.iconEmoji()
        nudge.priority = priority.rawValue
        nudge.state = status.rawValue
        nudge.createdAt = createdAt
        nudge.date = date.getStartOfDate()
        nudge.expiresAt = expiresAt
        nudge.actionType = actionType.rawValue
        nudge.actionValue = actionValue
        nudge.completedAt = completedAt
        nudge.snoozedUntil = snoozedUntil
    }
    
    mutating func markCompleted() {
        status = .completed
        completedAt = Date()
        snoozedUntil = nil
    }
    
    mutating func markDismissed() {
        status = .dismissed
        snoozedUntil = nil
    }
    
    mutating func markExpired() {
        status = .expired
    }
    
    var isVisible: Bool {
        guard status == .active else { return false }
        if let snoozedUntil, snoozedUntil > Date() { return false }
        if let expiresAt, expiresAt < Date() { return false }
        return true
    }
    
    static func calculateHealthScore(profile: ProfileModel, activity: DailyActivityModel) -> Int {
        var scores: [Double] = []
        
        if profile.waterTargetLiters > 0 {
            scores.append(min(1, activity.waterLiters / profile.waterTargetLiters))
        }
        if profile.calorieTarget > 0 {
            scores.append(min(1, activity.calories / profile.calorieTarget))
        }
        if profile.proteinTarget > 0 {
            scores.append(min(1, activity.protein / profile.proteinTarget))
        }
        if profile.stepTarget > 0 {
            scores.append(min(1, Double(activity.steps) / Double(profile.stepTarget)))
        }
        
        guard !scores.isEmpty else { return 0 }
        return Int((scores.reduce(0, +) / Double(scores.count)) * 100)
    }
    
    static func motivationalMessage(for score: Int) -> String {
        switch score {
        case 80...100:
            return AppTexts.nudgeMotivationExcellentText
        case 60..<80:
            return AppTexts.nudgeMotivationGoodText
        case 40..<60:
            return AppTexts.nudgeMotivationFairText
        default:
            return AppTexts.nudgeMotivationLowText
        }
    }
}
