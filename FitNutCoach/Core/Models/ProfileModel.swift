//
//  ProfileModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI

enum DietType: String, Codable {
    case veg, nonVeg, vegan
}

struct ProfileModel: Codable {
    var id: UUID? = UUID()
    var name: String
    var allergies: String?
    var calorieTarget: Double
    var carbTarget: Double
    var createdAt: Date?
    var dietType: DietType
    var dob: Date?
    var fatTarget: Double
    var proteinTarget: Double
    var stepTarget: Int32
    var waterTargetLiters: Double
    var weightKg: Double
    
    init(allergies: String? = nil, calorieTarget: Double, carbTarget: Double, createdAt: Date? = nil, dietType: DietType, dob: Date? = nil, fatTarget: Double, id: UUID? = nil, name: String, proteinTarget: Double, stepTarget: Int32, waterTargetLiters: Double, weightKg: Double) {
        self.allergies = allergies
        self.calorieTarget = calorieTarget
        self.carbTarget = carbTarget
        self.createdAt = createdAt
        self.dietType = dietType
        self.dob = dob
        self.fatTarget = fatTarget
        self.id = id
        self.name = name
        self.proteinTarget = proteinTarget
        self.stepTarget = stepTarget
        self.waterTargetLiters = waterTargetLiters
        self.weightKg = weightKg
    }
    
    init() {
        self.init(
            allergies: nil,
            calorieTarget: 0,
            carbTarget: 0,
            createdAt: Date(),
            dietType: .veg,
            dob: Date(),
            fatTarget: 0,
            id: UUID(),
            name: "",
            proteinTarget: 0,
            stepTarget: 0,
            waterTargetLiters: 0,
            weightKg: 0
        )
    }
    
    init(userProfile: UserProfile) {
        self.init(
            allergies: userProfile.allergies,
            calorieTarget: userProfile.calorieTarget,
            carbTarget: userProfile.carbTarget,
            createdAt: userProfile.createdAt,
            dietType: DietType(rawValue: userProfile.dietType ?? "") ?? .veg,
            dob: userProfile.dob,
            fatTarget: userProfile.fatTarget,
            id: userProfile.id,
            name: userProfile.name ?? "",
            proteinTarget: userProfile.proteinTarget,
            stepTarget: userProfile.stepTarget,
            waterTargetLiters: userProfile.waterTargetLiters,
            weightKg: userProfile.weightKg
        )
    }
    
    func fillUserProfile(userProfile: UserProfile) {
        userProfile.id = self.id
        userProfile.name = self.name
        userProfile.allergies = self.allergies
        userProfile.calorieTarget = self.calorieTarget
        userProfile.carbTarget = carbTarget
        userProfile.createdAt = createdAt
        userProfile.dietType = dietType.rawValue
        userProfile.dob = dob
        userProfile.fatTarget = fatTarget
        userProfile.proteinTarget = proteinTarget
        userProfile.stepTarget = stepTarget
        userProfile.waterTargetLiters = waterTargetLiters
        userProfile.weightKg = weightKg
    }
}
