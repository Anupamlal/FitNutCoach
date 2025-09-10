//
//  SplashView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 11/07/24.
//

import SwiftUI
import FirebaseAuth

struct SplashView: View {
    
    @EnvironmentObject private var appRootManager: AppRootManager
    
    var body: some View {
        ZStack {
            Color.primaryAccent
            
            Text(AppTexts.appName)
                .font(.system(size: AppSpacing.xl, weight: .bold))
                .foregroundStyle(Color.white)
            
        }
        .ignoresSafeArea()
        .onAppear(perform: {
            self.startTimerAndGoToTutorialView()
        })
        
    }
    
    func startTimerAndGoToTutorialView() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.setUpCurrentRoot()
        }
    }
    
    func setUpCurrentRoot(){
        if Auth.auth().currentUser != nil {
            
            Task {
                let nextRoot = await getNextAppRoot()
                
                DispatchQueue.main.async {
                    self.appRootManager.currentAppRoot = nextRoot
                }
            }
            
        }else{
            self.appRootManager.currentAppRoot = .login
        }
    }
    
    func getNextAppRoot() async -> AppRootType {
        
        if UserDefaultManager.isProfileSetupDone() {
            return .tabview
        }
        
        let profileModel = await appRootManager.profileManager.loadProfileFromServer()
        
        if profileModel == nil {
            return .profile
        }
        
        UserDefaultManager.saveProfileSetupDone(true)
        return .tabview
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
