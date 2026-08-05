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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appRootManager: AppRootManager
    
    init() {
        let container = PersistenceController.shared.container
        _appRootManager = StateObject(wrappedValue: AppRootManager(container: container))
    }
    
    var body: some Scene {
        WindowGroup {
            switch self.appRootManager.currentAppRoot {
                
            case .splash:
                SplashView()
                
            case .login:
                LoginView()
                
            case .profile:
                ProfileSetupView(profileManager: appRootManager.profileManager)
                
            case .tabview:
                RootTabView(
                    profileManager: appRootManager.profileManager,
                    dailyActivityManager: appRootManager.dailyActivityManager,
                    nudgeManager: appRootManager.nudgeManager
                )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
        .environmentObject(appRootManager)

    }
}
