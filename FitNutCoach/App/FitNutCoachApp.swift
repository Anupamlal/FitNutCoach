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
    
    init() {
        let container = PersistenceController.shared.container
        self.profileManager = ProfileManager(container: container)
    }
    
    var body: some Scene {
        WindowGroup {
            RootTabView(profileManager: profileManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
