//
//  ProfileSetupView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import SwiftUI

struct ProfileSetupView: View {
    
    @StateObject var profileSetupViewModel: ProfileSetupViewModel
    @EnvironmentObject var appRootManager: AppRootManager
    
    init(profileManager: ProfileManager) {
        _profileSetupViewModel = StateObject(wrappedValue: ProfileSetupViewModel(profileManager: profileManager))
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                FNButton(buttonTitle: AppTexts.confirmText, backgroundEnable: true) {
                    setUpProfile()
                }
                .padding(.horizontal, 24)
                
                if profileSetupViewModel.isLoading {
                    FNActivityIndicator()
                }
            }
            .withoutBackButton(withTitle: "Set Up Profile")
        }
        
    }
    
    func setUpProfile() {
        profileSetupViewModel.isLoading = true
        
        Task {
            let isProfileSetupDone = await profileSetupViewModel.setUpProfile()
            
            DispatchQueue.main.runInMainThread {
                profileSetupViewModel.isLoading = false

                if isProfileSetupDone {
                    self.appRootManager.currentAppRoot = .tabview
                }
            }
        }
    }
}

#Preview {
    ProfileSetupView(profileManager: ProfileManager(container: PersistenceController.shared.container))
}
