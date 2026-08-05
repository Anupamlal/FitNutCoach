//
//  EditProfileView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

struct EditProfileView: View {
    
    @StateObject private var viewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(profileManager: ProfileManager, profile: ProfileModel) {
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(profileManager: profileManager, profile: profile))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.l) {
                        profileSection(title: AppTexts.personalInfoText) {
                            profileTextField(title: AppTexts.nameText, text: $viewModel.name)
                            
                            DatePicker(
                                AppTexts.dateOfBirthText,
                                selection: $viewModel.dob,
                                displayedComponents: .date
                            )
                            .font(.system(size: 15, weight: .regular))
                            
                            profileTextField(title: AppTexts.heightText, text: $viewModel.heightCm, suffix: AppTexts.cmText, keyboard: .decimalPad)
                            profileTextField(title: AppTexts.weightText, text: $viewModel.weightKg, suffix: AppTexts.kgText, keyboard: .decimalPad)
                            
                            Picker(AppTexts.dietTypeText, selection: $viewModel.dietType) {
                                ForEach(DietType.allCases, id: \.self) { diet in
                                    Text(diet.displayName()).tag(diet)
                                }
                            }
                            .font(.system(size: 15, weight: .regular))
                            
                            profileTextField(title: AppTexts.allergiesText, text: $viewModel.allergies)
                        }
                        
                        profileSection(title: AppTexts.dailyTargetsText) {
                            profileTextField(title: AppTexts.calorieTargetText, text: $viewModel.calorieTarget, suffix: AppTexts.kcalText, keyboard: .decimalPad)
                            profileTextField(title: AppTexts.proteinTargetText, text: $viewModel.proteinTarget, suffix: AppTexts.gramsText, keyboard: .decimalPad)
                            profileTextField(title: AppTexts.carbTargetText, text: $viewModel.carbTarget, suffix: AppTexts.gramsText, keyboard: .decimalPad)
                            profileTextField(title: AppTexts.fatTargetText, text: $viewModel.fatTarget, suffix: AppTexts.gramsText, keyboard: .decimalPad)
                            profileTextField(title: AppTexts.waterTargetText, text: $viewModel.waterTargetLiters, suffix: AppTexts.litreText, keyboard: .decimalPad)
                            profileTextField(title: AppTexts.stepTargetText, text: $viewModel.stepTarget, suffix: AppTexts.stepsText, keyboard: .numberPad)
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        FNButton(
                            buttonTitle: AppTexts.saveProfileText,
                            backgroundEnable: true,
                            isEnabled: viewModel.isSaveEnabled
                        ) {
                            Task {
                                if await viewModel.save() {
                                    dismiss()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, AppSpacing.l)
                }
                
                if viewModel.isLoading {
                    FNActivityIndicator()
                }
            }
            .navigationTitle(AppTexts.editProfileText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppTexts.cancelText) {
                        dismiss()
                    }
                    .foregroundStyle(Color.primaryAccent)
                }
            }
        }
    }
    
    private func profileSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.m) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.textPrimary)
            
            sectionCard(content: content())
        }
    }
    
    private func sectionCard<Content: View>(content: Content) -> some View {
        Card {
            VStack(spacing: AppSpacing.m) {
                content
            }
        }
    }
    
    private func profileTextField(
        title: String,
        text: Binding<String>,
        suffix: String? = nil,
        keyboard: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.textSecondary)
            
            HStack {
                TextField(title, text: text)
                    .keyboardType(keyboard)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.textPrimary)
                
                if let suffix {
                    Text(suffix)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.divider.opacity(0.35))
            .cornerRadius(10)
        }
    }
}

#Preview {
    EditProfileView(
        profileManager: ProfileManager(container: PersistenceController.shared.container),
        profile: ProfileModel()
    )
}
