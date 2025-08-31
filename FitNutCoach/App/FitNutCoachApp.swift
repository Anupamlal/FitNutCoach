//
//  FitNutCoachApp.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 23/08/25.
//

import SwiftUI

@main
struct FitNutCoachApp: App {
    let persistenceController = PersistenceController.shared
    
    private let profileManager: ProfileManager
    private let dailyActivityManager: DailyActivityManager
    
    init() {
        let container = PersistenceController.shared.container
        self.profileManager = ProfileManager(container: container)
        self.dailyActivityManager = DailyActivityManager(container: container)
    }
    
    var body: some Scene {
        WindowGroup {
            RootTabView(profileManager: profileManager, dailyActivityManager: dailyActivityManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
