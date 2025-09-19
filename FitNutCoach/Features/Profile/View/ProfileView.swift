//
//  ProfileView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct ProfileView: View {
    
    @EnvironmentObject var appRootManager: AppRootManager
    @EnvironmentObject var homeNavRouter: Router<HomeRouter>

    
    var body: some View {
        NavigationView {
            VStack{
                FNButton(buttonTitle: "Logout", backgroundEnable: true) {
                    self.doLogoutAndGoToLogin()
                }
            }
            .padding(.horizontal, 24)
            .withoutBackButton(withTitle: "Profile")
    
        }
    }
    
    func doLogoutAndGoToLogin() {
        if logout() {
            DispatchQueue.main.runInMainThread {
                self.appRootManager.currentAppRoot = .login
            }
        }
    }
    
    func logout() -> Bool {
        
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            return true
            
        }catch {
            print(error)
        }
        return false
    }
}

#Preview {
    ProfileView()
}
