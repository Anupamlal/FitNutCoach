//
//  Equipment.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 19/02/26.
//


import SwiftUI

struct Equipment: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct EquipmentCategory: Identifiable {
    let id = UUID()
    let title: WorkoutType
    let equipments: [Equipment]
}


let equipmentCategories: [WorkoutType: EquipmentCategory] = [

    .chest: EquipmentCategory(
        title: .chest,
        equipments: [
            Equipment(name: "Barbell", color: .red),
            Equipment(name: "Dumbbells", color: .orange),
            Equipment(name: "Chest Press", color: .pink),
            Equipment(name: "Pec Deck", color: .mint)
        ]
    ),

    .shoulders: EquipmentCategory(
        title: .shoulders,
        equipments: [
            Equipment(name: "Dumbbells", color: .orange),
            Equipment(name: "Barbell", color: .red),
            Equipment(name: "Shoulder Press", color: .indigo),
            Equipment(name: "Cables", color: .cyan)
        ]
    ),

    .legs: EquipmentCategory(
        title: .legs,
        equipments: [
            Equipment(name: "Barbell", color: .red),
            Equipment(name: "Leg Press", color: .green),
            Equipment(name: "Leg Extension", color: .yellow),
            Equipment(name: "Leg Curl", color: .brown)
        ]
    ),

    WorkoutType.back: EquipmentCategory(
        title: .back,
        equipments: [
            Equipment(name: "Lat Pulldown", color: .blue),
            Equipment(name: "Seated Row", color: .teal),
            Equipment(name: "Barbell", color: .red),
            Equipment(name: "Pull-up Bar", color: .purple)
        ]
    ),

    .absBicepsTriceps: EquipmentCategory(
        title: .absBicepsTriceps,
        equipments: [
            Equipment(name: "Cables", color: .cyan),
            Equipment(name: "Dumbbells", color: .orange),
            Equipment(name: "EZ Bar", color: .gray),
            Equipment(name: "Ab Bench", color: .black)
        ]
    ),

    .cardio:
        EquipmentCategory(
            title: .cardio,
            equipments: [
                Equipment(name: "Treadmill", color: .red.opacity(0.8)),
                Equipment(name: "Bike", color: .blue.opacity(0.8)),
                Equipment(name: "Elliptical", color: .green.opacity(0.8)),
                Equipment(name: "Rower", color: .indigo.opacity(0.8))
            ]
        )
    

]
