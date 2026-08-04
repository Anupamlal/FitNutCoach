//
//  AppRootManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import UIKit
import CoreData

enum AppRootType {
    case splash
    case login
    case profile
    case tabview
}

class AppRootManager: ObservableObject {

    @Published var currentAppRoot: AppRootType = .splash
    let profileManager: ProfileManager
    let dailyActivityManager: DailyActivityManager
    let foodCatalogManager: FoodCatalogManager
    let nudgeManager: NudgeManager
    
    init(container: NSPersistentContainer) {
        self.profileManager = ProfileManager(container: container)
        self.dailyActivityManager = DailyActivityManager(container: container)
        self.foodCatalogManager = FoodCatalogManager(container: container)
        self.nudgeManager = NudgeManager(container: container)
    }
}
