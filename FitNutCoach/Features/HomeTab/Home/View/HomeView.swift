//
//  HomeView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct HomeView: View {
    
    //MARK: - Variables
    @StateObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var rootTabViewModel: RootTabViewModel
    
    init(profileManager: ProfileManager, dailyActivityManager: DailyActivityManager) {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(profileManager: profileManager, dailyActivityManager: dailyActivityManager))
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.l) {
                HStack {
                    Text("\(AppTexts.hiText) \(homeViewModel.profileModel.getProfileName()) 👋")
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
                
                ProgressRingsView(
                    profileModel: homeViewModel.profileModel,
                    dailyActivityModel: homeViewModel.dailyActivityModel, waterIntakeTapCallback: {
                        homeViewModel.openWaterIntakeView = true
                    })
                
                
                HStack{
                    FNButton(buttonTitle: AppTexts.logMealText, backgroundEnable: true) {
                        self.homeViewModel.openLogMealView = true
                    }
                    
                    FNButton(buttonTitle: AppTexts.startWorkoutText, backgroundEnable: false) {
                        rootTabViewModel.currentTab = .workouts
                    }
                }
                
                NutritionSnapshotView(
                    profileModel: homeViewModel.profileModel,
                    dailyActivityModel: homeViewModel.dailyActivityModel
                )
                
                Card {
                    HStack(spacing: AppSpacing.xs) {
                        Image("activityMonitor")
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        if (homeViewModel.numberOfWorkoutDays > 0) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(String(format: AppTexts.nWorkoutsThisWeekText, "\(homeViewModel.numberOfWorkoutDays)"))
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                
                                Text(AppTexts.keepItUpText)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .padding(.leading, 3)
                            
                        }else {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(AppTexts.noWorkoutsYetText)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                
                                Text(AppTexts.startItTodayText)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .padding(.leading, 3)
                        }
                        
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
                    .scrollIndicators(.hidden)
                    
                }
                
                Spacer()
            }
            .padding(.all)
        }
        .onFirstAppear {
            homeViewModel.onAppear()
        }
        .sheet(isPresented: $homeViewModel.openWaterIntakeView) {
            LogWaterView(totalWaterTarget: homeViewModel.profileModel.waterTargetLiters, dailyactvityManager: self.homeViewModel.getDailyActivityManager())
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
                
        }
        .sheet(isPresented: $homeViewModel.openLogMealView) {
            LogMealOptionsView(logMealCallback: { selectMealType in
                self.homeViewModel.setLogMealOption(selectedOption: selectMealType)
            })
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: $homeViewModel.openBarcodeScanner) {
            BarcodeView()
        }
    }
}

#Preview {
    HomeView(profileManager: ProfileManager(container: PersistenceController.shared.container), dailyActivityManager: DailyActivityManager(container: PersistenceController.shared.container))
}
