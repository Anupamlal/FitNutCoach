//
//  RootTabView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 23/08/25.
//


import SwiftUI

struct RootTabView: View {
    
    var profileManager: ProfileManager
    
    var body: some View {
        TabView {
            HomeView(profileManager: profileManager)
                .tabItem { Label("Home", systemImage: "house.fill") }

            WorkoutsView()
                .tabItem { Label("Workouts", systemImage: "figure.strengthtraining.traditional") }
            
            RecipesView()
                .tabItem { Label("Recipes", systemImage: "fork.knife") }
            
            TrendsView()
                .tabItem { Label("Trends", systemImage: "chart.line.uptrend.xyaxis") }
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .background {
            Color.white
        }
    }
}
