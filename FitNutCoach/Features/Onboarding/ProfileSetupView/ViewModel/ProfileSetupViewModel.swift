//
//  ProfileSetupViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import UIKit
import FirebaseAuth

class ProfileSetupViewModel: ObservableObject {

    private let profileManager: ProfileManager
    @Published var isLoading: Bool = false
    
    init(profileManager: ProfileManager) {
        self.profileManager = profileManager
    }
    
    func setUpProfile() async -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }
                
        let name = "Anupam Kumar Lal"
        
        let changeRequest = currentUser.createProfileChangeRequest()
        
        changeRequest.displayName = name
        
        guard let _ = try? await changeRequest.commitChanges() else {
            return false
        }
   
        let profileModel = ProfileModel(allergies: nil, calorieTarget: 2000, carbTarget: 250, createdAt: Date(), dietType: .veg, dob: Date(), fatTarget: 70, id: UUID().uuidString, name: name, proteinTarget: 150, stepTarget: 10000, waterTargetLiters: 4.0, weightKg: 70, heightCm: 160)
        
        let saved = await profileManager.saveProfile(profileModel)
        
        if saved {
            UserDefaultManager.saveProfileSetupDone(true)
        }
        
        return saved
    }
}
