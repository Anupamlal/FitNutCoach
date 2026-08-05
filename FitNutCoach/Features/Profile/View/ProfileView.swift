//
//  ProfileView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel: ProfileViewModel
    @StateObject private var profileRouter = Router<ProfileRouter>()
    @EnvironmentObject var appRootManager: AppRootManager
    
    init(profileManager: ProfileManager) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(profileManager: profileManager))
    }
    
    var body: some View {
        NavigationStack(path: $profileRouter.navigationPath) {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.l) {
                        headerCard
                        
                        Text(AppTexts.manageDetailsText)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        sectionLinks
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, AppSpacing.l)
                }
                
                if viewModel.isLoading {
                    FNActivityIndicator()
                }
            }
            .navigationTitle(AppTexts.profileTitleText)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ProfileRouter.self) { route in
                destination(for: route)
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
        .environmentObject(viewModel)
    }
    
    @ViewBuilder
    private func destination(for route: ProfileRouter) -> some View {
        switch route {
        case .personalInfo:
            PersonalInfoDetailView(
                profileManager: appRootManager.profileManager,
                profile: viewModel.profileModel
            )
        case .dailyTargets:
            DailyTargetsDetailView(
                profileManager: appRootManager.profileManager,
                profile: viewModel.profileModel
            )
        case .account:
            AccountDetailView()
        }
    }
    
    private var headerCard: some View {
        Card(backgroundColor: AppColors.logMealCardBGColor, spacing: AppSpacing.m) {
            HStack(spacing: AppSpacing.m) {
                ZStack {
                    Circle()
                        .fill(Color.primaryAccent.opacity(0.2))
                        .frame(width: 72, height: 72)
                    
                    Text(viewModel.profileModel.getProfileName().prefix(1).uppercased())
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color.primaryAccent)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.profileModel.name.isEmpty ? AppTexts.profileTitleText : viewModel.profileModel.name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                    
                    if !viewModel.userEmail.isEmpty {
                        Text(viewModel.userEmail)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    if viewModel.profileModel.calorieTarget > 0 {
                        Text("\(viewModel.profileModel.calorieTarget.intValue()) \(AppTexts.kcalText) daily goal")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.primaryAccent)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var sectionLinks: some View {
        VStack(spacing: AppSpacing.m) {
            Button {
                profileRouter.navigate(to: .personalInfo)
            } label: {
                ProfileSectionRow(
                    icon: "person.fill",
                    iconColor: AppColors.protienColor,
                    iconBackground: AppColors.protienColor.opacity(0.15),
                    title: AppTexts.personalInfoText,
                    subtitle: viewModel.personalInfoSummary()
                )
            }
            .buttonStyle(.plain)
            
            Button {
                profileRouter.navigate(to: .dailyTargets)
            } label: {
                ProfileSectionRow(
                    icon: "target",
                    iconColor: AppColors.calorieProgressColor,
                    iconBackground: AppColors.calorieTotalColor,
                    title: AppTexts.dailyTargetsText,
                    subtitle: viewModel.dailyTargetsSummary()
                )
            }
            .buttonStyle(.plain)
            
            Button {
                profileRouter.navigate(to: .account)
            } label: {
                ProfileSectionRow(
                    icon: "envelope.fill",
                    iconColor: AppColors.waterProgressColor,
                    iconBackground: AppColors.waterTotalColor,
                    title: AppTexts.accountText,
                    subtitle: viewModel.userEmail.isEmpty ? AppTexts.accountSubtitleText : viewModel.userEmail
                )
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    ProfileView(profileManager: ProfileManager(container: PersistenceController.shared.container))
        .environmentObject(AppRootManager(container: PersistenceController.shared.container))
}
