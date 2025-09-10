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
        if let currentUser = Auth.auth().currentUser {
            
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
        
        let profileModel = await ProfileFBHelper.getUserProfile()
        
        if profileModel == nil {
            return .profile
        }
        
        return .tabview
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
