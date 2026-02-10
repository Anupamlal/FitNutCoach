//
//  NudgeModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 16/10/25.
//

import UIKit

enum NudgeType: String, Codable {
    case weather
    case food
    case exercise
}

enum NudgeState: String, Codable {
    case active
    case snoozed
    case done
    case dismissed
}

struct NudgeModel: Codable {
    let id: String
    let message: String?
    let title: String?
    let icon: String?
    let type: NudgeType
    let priority: Int16
    var state: NudgeState
    let createdAt: Date
    var snoozedUntil: Date?
    let expiresAt: Date?
    
    init(id: String, message: String?, title: String?, icon: String?, type: NudgeType, priority: Int16, state: NudgeState, createdAt: Date, snoozedUntil: Date?, expiresAt: Date?) {
        self.id = id
        self.message = message
        self.title = title
        self.icon = icon
        self.type = type
        self.priority = priority
        self.state = state
        self.createdAt = createdAt
        self.snoozedUntil = snoozedUntil
        self.expiresAt = expiresAt
    }
    
    init() {
        self.init(id: "", message: nil, title: nil, icon: nil, type: .weather, priority: 1, state: .active, createdAt: Date(), snoozedUntil: nil, expiresAt: nil)
    }
    
    init(with nudge: Nudge) {
        self.id = nudge.id ?? UUID().uuidString
        self.message = nudge.message
        self.title = nudge.title
        self.icon = nudge.icon
        if let type = NudgeType(rawValue: nudge.type ?? "") {
            self.type = type
        } else {
            self.type = .weather
        }
        self.priority = nudge.priority
        if let state = NudgeState(rawValue: nudge.state ?? "") {
            self.state = state
        } else {
            self.state = .active
        }
        self.createdAt = nudge.createdAt ?? Date()
        self.expiresAt = nudge.expiresAt
        self.snoozedUntil = nudge.snoozedUntil
    }
    
    func fill(into nudge: Nudge) {
        nudge.id = id
        nudge.message = message
        nudge.title = title
        nudge.icon = icon
        nudge.type = type.rawValue
        nudge.priority = priority
        nudge.state = state.rawValue
        nudge.createdAt = createdAt.getStartOfDate()
        nudge.snoozedUntil = snoozedUntil
        nudge.expiresAt = expiresAt
    }
    
    mutating func updateState(to newState: NudgeState) {
        self.state = newState
    }
}
