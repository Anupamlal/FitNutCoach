//
//  EditProfileViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

final class EditProfileViewModel: ObservableObject {
    
    @Published var name: String
    @Published var dob: Date
    @Published var heightCm: String
    @Published var weightKg: String
    @Published var dietType: DietType
    @Published var allergies: String
    @Published var calorieTarget: String
    @Published var proteinTarget: String
    @Published var carbTarget: String
    @Published var fatTarget: String
    @Published var waterTargetLiters: String
    @Published var stepTarget: String
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSaveSuccessfully = false
    
    private let profileManager: ProfileManager
    private let existingProfile: ProfileModel
    
    init(profileManager: ProfileManager, profile: ProfileModel) {
        self.profileManager = profileManager
        self.existingProfile = profile
        
        name = profile.name
        dob = profile.dob ?? Date()
        heightCm = profile.heightCm > 0 ? profile.heightCm.formatToOneDecimalPlaces() : ""
        weightKg = profile.weightKg > 0 ? profile.weightKg.formatToOneDecimalPlaces() : ""
        dietType = profile.dietType
        allergies = profile.allergies ?? ""
        calorieTarget = profile.calorieTarget > 0 ? profile.calorieTarget.formatToOneDecimalPlaces() : ""
        proteinTarget = profile.proteinTarget > 0 ? profile.proteinTarget.formatToOneDecimalPlaces() : ""
        carbTarget = profile.carbTarget > 0 ? profile.carbTarget.formatToOneDecimalPlaces() : ""
        fatTarget = profile.fatTarget > 0 ? profile.fatTarget.formatToOneDecimalPlaces() : ""
        waterTargetLiters = profile.waterTargetLiters > 0 ? profile.waterTargetLiters.formatToOneDecimalPlaces() : ""
        stepTarget = profile.stepTarget > 0 ? "\(profile.stepTarget)" : ""
    }
    
    var isSaveEnabled: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func save() async -> Bool {
        guard isSaveEnabled else { return false }
        
        let profile = ProfileModel(
            allergies: allergies.trimmingCharacters(in: .whitespaces).isEmpty ? nil : allergies,
            calorieTarget: Double(calorieTarget) ?? 0,
            carbTarget: Double(carbTarget) ?? 0,
            createdAt: existingProfile.createdAt ?? Date(),
            dietType: dietType,
            dob: dob,
            fatTarget: Double(fatTarget) ?? 0,
            id: existingProfile.id,
            name: name.trimmingCharacters(in: .whitespaces),
            proteinTarget: Double(proteinTarget) ?? 0,
            stepTarget: Int32(stepTarget) ?? 0,
            waterTargetLiters: Double(waterTargetLiters) ?? 0,
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
            if saved {
                didSaveSuccessfully = true
            } else {
                errorMessage = AppTexts.profileSaveFailedText
            }
        }
        
        return saved
    }
}
