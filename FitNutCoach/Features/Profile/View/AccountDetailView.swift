//
//  AccountDetailView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

struct AccountDetailView: View {
    
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.l) {
                Card(backgroundColor: AppColors.foodCardBGColor) {
                    HStack(spacing: AppSpacing.m) {
                        ZStack {
                            Circle()
                                .fill(Color.primaryAccent.opacity(0.15))
                                .frame(width: 56, height: 56)
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(Color.primaryAccent)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(AppTexts.emailText)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.textSecondary)
                            Text(profileViewModel.userEmail.isEmpty ? AppTexts.noneText : profileViewModel.userEmail)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.textPrimary)
                        }
                        Spacer()
                    }
                }
                
                Card {
                    FNKeyValueView(
                        keyName: AppTexts.emailText,
                        valueName: profileViewModel.userEmail.isEmpty ? AppTexts.noneText : profileViewModel.userEmail
                    )
                }
                
                Text(AppTexts.accountSubtitleText)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                FNButton(buttonTitle: AppTexts.logoutText, backgroundEnable: false) {
                    _ = profileViewModel.logout(appRootManager: appRootManager)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, AppSpacing.l)
        }
        .navigationTitle(AppTexts.accountText)
        .navigationBarTitleDisplayMode(.inline)
    }
}
