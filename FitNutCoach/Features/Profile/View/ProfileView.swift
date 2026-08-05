//
//  ProfileView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject var appRootManager: AppRootManager
    
    init(profileManager: ProfileManager) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(profileManager: profileManager))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.l) {
                        headerCard
                        personalInfoSection
                        dailyTargetsSection
                        accountSection
                        
                        FNButton(buttonTitle: AppTexts.editProfileText, backgroundEnable: true) {
                            viewModel.showEditProfile = true
                        }
                        
                        FNButton(buttonTitle: AppTexts.logoutText, backgroundEnable: false) {
                            _ = viewModel.logout(appRootManager: appRootManager)
                        }
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
            .onAppear {
                viewModel.onAppear()
            }
            .sheet(isPresented: $viewModel.showEditProfile) {
                EditProfileView(
                    profileManager: appRootManager.profileManager,
                    profile: viewModel.profileModel
                )
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var headerCard: some View {
        Card {
            HStack(spacing: AppSpacing.m) {
                ZStack {
                    Circle()
                        .fill(Color.primaryAccent.opacity(0.15))
                        .frame(width: 64, height: 64)
                    
                    Text(viewModel.profileModel.getProfileName().prefix(1).uppercased())
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.primaryAccent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.profileModel.name.isEmpty ? AppTexts.profileTitleText : viewModel.profileModel.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                    
                    if !viewModel.userEmail.isEmpty {
                        Text(viewModel.userEmail)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var personalInfoSection: some View {
        sectionCard(
            title: AppTexts.personalInfoText,
            rows: [
                (AppTexts.dateOfBirthText, viewModel.formattedDOB()),
                (AppTexts.heightText, viewModel.formattedHeight()),
                (AppTexts.weightText, viewModel.formattedWeight()),
                (AppTexts.dietTypeText, viewModel.profileModel.dietType.displayName()),
                (AppTexts.allergiesText, viewModel.profileModel.allergies ?? AppTexts.noneText)
            ]
        )
    }
    
    private var dailyTargetsSection: some View {
        sectionCard(
            title: AppTexts.dailyTargetsText,
            rows: [
                (AppTexts.calorieTargetText, targetValue(viewModel.profileModel.calorieTarget, suffix: AppTexts.kcalText)),
                (AppTexts.proteinTargetText, targetValue(viewModel.profileModel.proteinTarget, suffix: AppTexts.gramsText)),
                (AppTexts.carbTargetText, targetValue(viewModel.profileModel.carbTarget, suffix: AppTexts.gramsText)),
                (AppTexts.fatTargetText, targetValue(viewModel.profileModel.fatTarget, suffix: AppTexts.gramsText)),
                (AppTexts.waterTargetText, targetValue(viewModel.profileModel.waterTargetLiters, suffix: AppTexts.litreText)),
                (AppTexts.stepTargetText, viewModel.profileModel.stepTarget > 0 ? "\(viewModel.profileModel.stepTarget) \(AppTexts.stepsText)" : AppTexts.noneText)
            ]
        )
    }
    
    private var accountSection: some View {
        sectionCard(
            title: AppTexts.accountText,
            rows: [
                (AppTexts.emailText, viewModel.userEmail.isEmpty ? AppTexts.noneText : viewModel.userEmail)
            ]
        )
    }
    
    private func sectionCard(title: String, rows: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.textPrimary)
            
            Card {
                VStack(spacing: 0) {
                    ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                        FNKeyValueView(keyName: row.0, valueName: row.1)
                        
                        if index < rows.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    private func targetValue(_ value: Double, suffix: String) -> String {
        guard value > 0 else { return AppTexts.noneText }
        return "\(value.formatToOneDecimalPlaces()) \(suffix)"
    }
}

#Preview {
    ProfileView(profileManager: ProfileManager(container: PersistenceController.shared.container))
        .environmentObject(AppRootManager(container: PersistenceController.shared.container))
}
