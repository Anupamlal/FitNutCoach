//
//  LoginView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct LoginView: View {
    
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject private var appRootManager: AppRootManager
    
    var body: some View {
        VStack {
            
            Text("🏋️")
                .font(.system(size: 70))
            
            Spacer()
                .frame(height: 50)
            
            
            Text("Welcome to FitNut Coach")
                .font(.largeTitle)
            
            Spacer()
                .frame(height: 15)
            
            Text("Your fitness journey start from here")
                .font(.subheadline)
            
            Spacer()
                .frame(height: 50)
            
            FNButton(buttonTitle: "Login with Google", backgroundEnable: true) {
                loginWithGoogle()
            }
        }
        .padding(.horizontal, 20)
    }
    
    func loginWithGoogle() {
        
        guard let currentVC = self.loginViewModel.getCurrentController() else {
            return
        }
        
        loginViewModel.signInWithGoogle(currentVC: currentVC) { isSuccess in
            if isSuccess {
                    
                Task {
                    let root = await loginViewModel.getNextAppRoot()
                    
                    DispatchQueue.main.async {
                        self.appRootManager.currentAppRoot = root
                    }
                }
                    
            }
        }
            
    }
}

#Preview {
    LoginView()
}
