//
//  DailyTargetsDetailView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

struct DailyTargetsDetailView: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @State private var isEditing = false
    @StateObject private var editViewModel: DailyTargetsEditViewModel
    
    init(profileManager: ProfileManager, profile: ProfileModel) {
        _editViewModel = StateObject(
            wrappedValue: DailyTargetsEditViewModel(profileManager: profileManager, profile: profile)
        )
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.l) {
                    if isEditing {
                        editForm
                    } else {
                        detailContent
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, AppSpacing.l)
            }
            
            if editViewModel.isLoading {
                FNActivityIndicator()
            }
        }
        .navigationTitle(AppTexts.dailyTargetsText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? AppTexts.cancelText : AppTexts.editText) {
                    if isEditing {
                        syncEditFormFromProfile()
                        isEditing = false
                    } else {
                        syncEditFormFromProfile()
                        isEditing = true
                    }
                }
                .foregroundStyle(Color.primaryAccent)
            }
        }
    }
    
    private var detailContent: some View {
        VStack(spacing: AppSpacing.l) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.m) {
                ProfileTargetCard(
                    title: AppTexts.caloriesText,
                    value: targetDisplay(profileViewModel.profileModel.calorieTarget, suffix: AppTexts.kcalText),
                    color: AppColors.calorieProgressColor,
                    backgroundColor: AppColors.calorieTotalColor
                )
                ProfileTargetCard(
                    title: AppTexts.proteinText,
                    value: targetDisplay(profileViewModel.profileModel.proteinTarget, suffix: AppTexts.gramsText),
                    color: AppColors.protienColor,
                    backgroundColor: AppColors.protienColor.opacity(0.12)
                )
                ProfileTargetCard(
                    title: AppTexts.carbsText,
                    value: targetDisplay(profileViewModel.profileModel.carbTarget, suffix: AppTexts.gramsText),
                    color: AppColors.carbsColor,
                    backgroundColor: AppColors.carbsColor.opacity(0.15)
                )
                ProfileTargetCard(
                    title: AppTexts.fatText,
                    value: targetDisplay(profileViewModel.profileModel.fatTarget, suffix: AppTexts.gramsText),
                    color: AppColors.fatColor,
                    backgroundColor: AppColors.fatColor.opacity(0.12)
                )
                ProfileTargetCard(
                    title: AppTexts.waterTargetText,
                    value: targetDisplay(profileViewModel.profileModel.waterTargetLiters, suffix: AppTexts.litreText),
                    color: AppColors.waterProgressColor,
                    backgroundColor: AppColors.waterTotalColor
                )
                ProfileTargetCard(
                    title: AppTexts.stepTargetText,
                    value: profileViewModel.profileModel.stepTarget > 0 ? "\(profileViewModel.profileModel.stepTarget) \(AppTexts.stepsText)" : AppTexts.noneText,
                    color: AppColors.stepsProgressColor,
                    backgroundColor: AppColors.stepsTotalColor
                )
            }
            
            Card {
                VStack(spacing: 0) {
                    FNKeyValueView(keyName: AppTexts.calorieTargetText, valueName: targetDisplay(profileViewModel.profileModel.calorieTarget, suffix: AppTexts.kcalText))
                    Divider()
                    FNKeyValueView(keyName: AppTexts.proteinTargetText, valueName: targetDisplay(profileViewModel.profileModel.proteinTarget, suffix: AppTexts.gramsText))
                    Divider()
                    FNKeyValueView(keyName: AppTexts.carbTargetText, valueName: targetDisplay(profileViewModel.profileModel.carbTarget, suffix: AppTexts.gramsText))
                    Divider()
                    FNKeyValueView(keyName: AppTexts.fatTargetText, valueName: targetDisplay(profileViewModel.profileModel.fatTarget, suffix: AppTexts.gramsText))
                    Divider()
                    FNKeyValueView(keyName: AppTexts.waterTargetText, valueName: targetDisplay(profileViewModel.profileModel.waterTargetLiters, suffix: AppTexts.litreText))
                    Divider()
                    FNKeyValueView(keyName: AppTexts.stepTargetText, valueName: profileViewModel.profileModel.stepTarget > 0 ? "\(profileViewModel.profileModel.stepTarget) \(AppTexts.stepsText)" : AppTexts.noneText)
                }
            }
        }
    }
    
    private var editForm: some View {
        VStack(spacing: AppSpacing.l) {
            Card {
                VStack(spacing: AppSpacing.m) {
                    ProfileFormField(title: AppTexts.calorieTargetText, text: $editViewModel.calorieTarget, suffix: AppTexts.kcalText, keyboard: .decimalPad)
                    ProfileFormField(title: AppTexts.proteinTargetText, text: $editViewModel.proteinTarget, suffix: AppTexts.gramsText, keyboard: .decimalPad)
                    ProfileFormField(title: AppTexts.carbTargetText, text: $editViewModel.carbTarget, suffix: AppTexts.gramsText, keyboard: .decimalPad)
                    ProfileFormField(title: AppTexts.fatTargetText, text: $editViewModel.fatTarget, suffix: AppTexts.gramsText, keyboard: .decimalPad)
                    ProfileFormField(title: AppTexts.waterTargetText, text: $editViewModel.waterTargetLiters, suffix: AppTexts.litreText, keyboard: .decimalPad)
                    ProfileFormField(title: AppTexts.stepTargetText, text: $editViewModel.stepTarget, suffix: AppTexts.stepsText, keyboard: .numberPad)
                }
            }
            
            if let errorMessage = editViewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            FNButton(buttonTitle: AppTexts.saveProfileText, backgroundEnable: true) {
                Task {
                    if await editViewModel.save() {
                        isEditing = false
                    }
                }
            }
        }
    }
    
    private func targetDisplay(_ value: Double, suffix: String) -> String {
        guard value > 0 else { return AppTexts.noneText }
        return "\(value.formatToOneDecimalPlaces()) \(suffix)"
    }
    
    private func syncEditFormFromProfile() {
        let profile = profileViewModel.profileModel
        editViewModel.calorieTarget = profile.calorieTarget > 0 ? profile.calorieTarget.formatToOneDecimalPlaces() : ""
        editViewModel.proteinTarget = profile.proteinTarget > 0 ? profile.proteinTarget.formatToOneDecimalPlaces() : ""
        editViewModel.carbTarget = profile.carbTarget > 0 ? profile.carbTarget.formatToOneDecimalPlaces() : ""
        editViewModel.fatTarget = profile.fatTarget > 0 ? profile.fatTarget.formatToOneDecimalPlaces() : ""
        editViewModel.waterTargetLiters = profile.waterTargetLiters > 0 ? profile.waterTargetLiters.formatToOneDecimalPlaces() : ""
        editViewModel.stepTarget = profile.stepTarget > 0 ? "\(profile.stepTarget)" : ""
        editViewModel.errorMessage = nil
    }
}
