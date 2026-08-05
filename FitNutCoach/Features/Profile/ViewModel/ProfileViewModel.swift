//
//  ProfileViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI
import Combine
import FirebaseAuth
import GoogleSignIn

class ProfileViewModel: ObservableObject {
    
    @Published var profileModel = ProfileModel()
    @Published var userEmail: String = ""
    @Published var isLoading = false
    @Published var showEditProfile = false
    
    private let profileManager: ProfileManager
    private var cancellables = Set<AnyCancellable>()
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
        
        profileManager.managerPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                self?.profileModel = profile
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        userEmail = Auth.auth().currentUser?.email ?? ""
        isLoading = true

        Task {
            if await profileManager.loadData() == false {
                _ = await profileManager.loadProfileFromServer()
            }
            await MainActor.run { isLoading = false }
        }
    }
    
    func logout(appRootManager: AppRootManager) -> Bool {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                appRootManager.currentAppRoot = .login
                // Need to clear the user defaults as well
            }
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func formattedDOB() -> String {
        guard let dob = profileModel.dob else { return AppTexts.noneText }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dob)
    }
    
    func formattedHeight() -> String {
        guard profileModel.heightCm > 0 else { return AppTexts.noneText }
        return "\(profileModel.heightCm.formatToOneDecimalPlaces()) \(AppTexts.cmText)"
    }
    
    func formattedWeight() -> String {
        guard profileModel.weightKg > 0 else { return AppTexts.noneText }
        return "\(profileModel.weightKg.formatToOneDecimalPlaces()) \(AppTexts.kgText)"
    }
}
