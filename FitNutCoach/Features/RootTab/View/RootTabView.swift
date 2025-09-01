//
//  RootTabView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 23/08/25.
//


import SwiftUI

enum RootTabSection : Int {
    case home = 0
    case workouts
    case recipes
    case trends
    case profile
}

struct RootTabView: View {
    
    var profileManager: ProfileManager
    var dailyActivityManager: DailyActivityManager
    @StateObject var rootTabViewModel = RootTabViewModel()
    
    var body: some View {
        TabView(selection: $rootTabViewModel.currentTab) {
            HomeView(profileManager: profileManager, dailyActivityManager: dailyActivityManager)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(RootTabSection.home)

            WorkoutsView()
                .tabItem { Label("Workouts", systemImage: "figure.strengthtraining.traditional") }
                .tag(RootTabSection.workouts)
            
            RecipesView()
                .tabItem { Label("Recipes", systemImage: "fork.knife") }
                .tag(RootTabSection.recipes)
            
            TrendsView()
                .tabItem { Label("Trends", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(RootTabSection.trends)
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(RootTabSection.profile)
        }
        .environmentObject(self.rootTabViewModel)
    }
}
