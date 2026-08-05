//
//  DailyTargetsEditViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

final class DailyTargetsEditViewModel: ObservableObject {
    
    @Published var calorieTarget: String
    @Published var proteinTarget: String
    @Published var carbTarget: String
    @Published var fatTarget: String
    @Published var waterTargetLiters: String
    @Published var stepTarget: String
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let profileManager: ProfileManager
    
    init(profileManager: ProfileManager, profile: ProfileModel) {
        self.profileManager = profileManager
        calorieTarget = profile.calorieTarget > 0 ? profile.calorieTarget.formatToOneDecimalPlaces() : ""
        proteinTarget = profile.proteinTarget > 0 ? profile.proteinTarget.formatToOneDecimalPlaces() : ""
        carbTarget = profile.carbTarget > 0 ? profile.carbTarget.formatToOneDecimalPlaces() : ""
        fatTarget = profile.fatTarget > 0 ? profile.fatTarget.formatToOneDecimalPlaces() : ""
        waterTargetLiters = profile.waterTargetLiters > 0 ? profile.waterTargetLiters.formatToOneDecimalPlaces() : ""
        stepTarget = profile.stepTarget > 0 ? "\(profile.stepTarget)" : ""
    }
    
    func save() async -> Bool {
        let current = profileManager.getCurrentProfile()
        let profile = ProfileModel(
            allergies: current.allergies,
            calorieTarget: Double(calorieTarget) ?? 0,
            carbTarget: Double(carbTarget) ?? 0,
            createdAt: current.createdAt ?? Date(),
            dietType: current.dietType,
            dob: current.dob,
            fatTarget: Double(fatTarget) ?? 0,
            id: current.id,
            name: current.name,
            proteinTarget: Double(proteinTarget) ?? 0,
            stepTarget: Int32(stepTarget) ?? 0,
            waterTargetLiters: Double(waterTargetLiters) ?? 0,
            weightKg: current.weightKg,
            heightCm: current.heightCm
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
