//
//  AppDelegate.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 23/08/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        self.unAuthOldUser()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

//MARK: - Firebase UnAuth Function
extension AppDelegate {
    
    func unAuthOldUser(){
        
        if UserDefaults.standard.value(forKey: UserDefaultConstant.isNewUser) == nil {
            
            UserDefaults.standard.set(true, forKey: UserDefaultConstant.isNewUser)
            
            do {
                try Auth.auth().signOut()
                
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
    }
}
