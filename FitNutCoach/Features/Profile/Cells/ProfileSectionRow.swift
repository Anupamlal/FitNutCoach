//
//  ProfileSectionRow.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

struct ProfileSectionRow: View {
    
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        Card {
            HStack(spacing: AppSpacing.m) {
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer(minLength: 8)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
            }
        }
    }
}

#Preview {
    ProfileSectionRow(
        icon: "person.fill",
        iconColor: AppColors.protienColor,
        iconBackground: AppColors.protienColor.opacity(0.15),
        title: "Personal Info",
        subtitle: "Body metrics, diet & allergies"
    )
    .padding()
}
