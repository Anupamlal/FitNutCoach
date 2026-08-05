//
//  PersonalInfoDetailView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

struct PersonalInfoDetailView: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @State private var isEditing = false
    @StateObject private var editViewModel: PersonalInfoEditViewModel
    
    init(profileManager: ProfileManager, profile: ProfileModel) {
        _editViewModel = StateObject(
            wrappedValue: PersonalInfoEditViewModel(profileManager: profileManager, profile: profile)
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
        .navigationTitle(AppTexts.personalInfoText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? AppTexts.cancelText : AppTexts.editText) {
                    if isEditing {
                        resetEditForm()
                        isEditing = false
                    } else {
                        syncEditFormFromProfile()
                        isEditing = true
                    }
                }
                .foregroundStyle(Color.primaryAccent)
            }
        }
        .onChange(of: profileViewModel.profileModel.id) { _, _ in
            if !isEditing {
                syncEditFormFromProfile()
            }
        }
    }
    
    private var detailContent: some View {
        VStack(spacing: AppSpacing.l) {
            Card(backgroundColor: AppColors.logMealCardBGColor) {
                HStack(spacing: AppSpacing.m) {
                    ZStack {
                        Circle()
                            .fill(Color.primaryAccent.opacity(0.2))
                            .frame(width: 56, height: 56)
                        Image(systemName: "person.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color.primaryAccent)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(profileViewModel.profileModel.name.isEmpty ? AppTexts.noneText : profileViewModel.profileModel.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                        Text(AppTexts.tapToEditText)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer()
                }
            }
            
            Card {
                VStack(spacing: 0) {
                    FNKeyValueView(keyName: AppTexts.nameText, valueName: profileViewModel.profileModel.name.isEmpty ? AppTexts.noneText : profileViewModel.profileModel.name)
                    Divider()
                    FNKeyValueView(keyName: AppTexts.dateOfBirthText, valueName: profileViewModel.formattedDOB())
                    Divider()
                    FNKeyValueView(keyName: AppTexts.heightText, valueName: profileViewModel.formattedHeight())
                    Divider()
                    FNKeyValueView(keyName: AppTexts.weightText, valueName: profileViewModel.formattedWeight())
                    Divider()
                    FNKeyValueView(keyName: AppTexts.dietTypeText, valueName: profileViewModel.profileModel.dietType.displayName())
                    Divider()
                    FNKeyValueView(keyName: AppTexts.allergiesText, valueName: profileViewModel.profileModel.allergies ?? AppTexts.noneText)
                }
            }
        }
    }
    
    private var editForm: some View {
        VStack(spacing: AppSpacing.l) {
            Card {
                VStack(spacing: AppSpacing.m) {
                    ProfileFormField(title: AppTexts.nameText, text: $editViewModel.name)
                    
                    DatePicker(
                        AppTexts.dateOfBirthText,
                        selection: $editViewModel.dob,
                        displayedComponents: .date
                    )
                    .font(.system(size: 15, weight: .regular))
                    
                    ProfileFormField(title: AppTexts.heightText, text: $editViewModel.heightCm, suffix: AppTexts.cmText, keyboard: .decimalPad)
                    ProfileFormField(title: AppTexts.weightText, text: $editViewModel.weightKg, suffix: AppTexts.kgText, keyboard: .decimalPad)
                    
                    HStack(alignment: .center, spacing: 6) {
                        Text(AppTexts.dietTypeText)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.textSecondary)
                            .frame(width: 65)
                        
                        Spacer()
                        
                        Picker(AppTexts.dietTypeText, selection: $editViewModel.dietType) {
                            ForEach(DietType.allCases, id: \.self) { diet in
                                Text(diet.displayName()).tag(diet)
                                    .font(.system(size: 12, weight: .medium))
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    ProfileFormField(title: AppTexts.allergiesText, text: $editViewModel.allergies)
                }
            }
            
            if let errorMessage = editViewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            FNButton(
                buttonTitle: AppTexts.saveProfileText,
                backgroundEnable: true,
                isEnabled: editViewModel.isSaveEnabled
            ) {
                Task {
                    if await editViewModel.save() {
                        isEditing = false
                    }
                }
            }
        }
    }
    
    private func syncEditFormFromProfile() {
        let profile = profileViewModel.profileModel
        editViewModel.name = profile.name
        editViewModel.dob = profile.dob ?? Date()
        editViewModel.heightCm = profile.heightCm > 0 ? profile.heightCm.formatToOneDecimalPlaces() : ""
        editViewModel.weightKg = profile.weightKg > 0 ? profile.weightKg.formatToOneDecimalPlaces() : ""
        editViewModel.dietType = profile.dietType
        editViewModel.allergies = profile.allergies ?? ""
        editViewModel.errorMessage = nil
    }
    
    private func resetEditForm() {
        syncEditFormFromProfile()
    }
}
