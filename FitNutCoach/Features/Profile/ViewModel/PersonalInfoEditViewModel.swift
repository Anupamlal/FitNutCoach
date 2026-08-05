//
//  PersonalInfoEditViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

final class PersonalInfoEditViewModel: ObservableObject {
    
    @Published var name: String
    @Published var dob: Date
    @Published var heightCm: String
    @Published var weightKg: String
    @Published var dietType: DietType
    @Published var allergies: String
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let profileManager: ProfileManager
    
    init(profileManager: ProfileManager, profile: ProfileModel) {
        self.profileManager = profileManager
        name = profile.name
        dob = profile.dob ?? Date()
        heightCm = profile.heightCm > 0 ? profile.heightCm.formatToOneDecimalPlaces() : ""
        weightKg = profile.weightKg > 0 ? profile.weightKg.formatToOneDecimalPlaces() : ""
        dietType = profile.dietType
        allergies = profile.allergies ?? ""
    }
    
    var isSaveEnabled: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func save() async -> Bool {
        guard isSaveEnabled else { return false }
        
        let current = profileManager.getCurrentProfile()
        let profile = ProfileModel(
            allergies: allergies.trimmingCharacters(in: .whitespaces).isEmpty ? nil : allergies,
            calorieTarget: current.calorieTarget,
            carbTarget: current.carbTarget,
            createdAt: current.createdAt ?? Date(),
            dietType: dietType,
            dob: dob,
            fatTarget: current.fatTarget,
            id: current.id,
            name: name.trimmingCharacters(in: .whitespaces),
            proteinTarget: current.proteinTarget,
            stepTarget: current.stepTarget,
            waterTargetLiters: current.waterTargetLiters,
            weightKg: Double(weightKg) ?? 0,
            heightCm: Double(heightCm) ?? 0
        )
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        let saved = await profileManager.saveProfile(profile)
        
        await MainActor.run {
            isLoading = false
            if !saved {
                errorMessage = AppTexts.profileSaveFailedText
            }
        }
        
        return saved
    }
}
