//
//  HomeView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct HomeView: View {
    
    //MARK: - Variables
    var homeViewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.l) {
                HStack {
                    Text("\(AppTexts.hiText) \(homeViewModel.loggedInUserName) 👋")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                    
                    Spacer()
                    
                    Text("☀️ 28°C Sunny")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.textSecondary)
                        .padding(.all, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.divider)
                        }
                }
                
                ProgressRingsView()
                
                HStack{
                    FNButton(buttonTitle: AppTexts.logMealText, backgroundEnable: true) {
                        
                    }
                    
                    FNButton(buttonTitle: AppTexts.startWorkoutText, backgroundEnable: false) {
                        
                    }
                }
                
                NutritionSnapshotView()
                
                Card {
                    HStack(spacing: AppSpacing.xs) {
                        Image("activityMonitor")
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(format: AppTexts.nWorkoutsThisWeekText, "\(homeViewModel.numberOfWorkoutDays)"))
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(Color.textPrimary)
                            
                            Text(AppTexts.keepItUpText)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(Color.textSecondary)
                        }
                        .padding(.leading, 3)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                }
                .onTapGesture {
                    
                }
                
                Card(backgroundColor: AppColors.waterTotalColor) {
                    HStack{
                        Image("bulbImage")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        Text("Hot today - hydrate more and shift workout to AM")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color.textPrimary)
                        
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(AppTexts.nextMealIdeasText)
                        .font(.system(size: 20, weight: .semibold))
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: AppSpacing.m) {
                            ForEach(0..<10, id: \.self) { _ in
                                QuickRecipesView()
                            }
                        }
                        
                    }
                    
                }
                
                Spacer()
            }
            .padding(.all)
        }
    }
}

#Preview {
    HomeView()
}
