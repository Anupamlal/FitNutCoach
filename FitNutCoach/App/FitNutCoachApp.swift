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

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
