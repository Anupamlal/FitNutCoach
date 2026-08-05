//
//  ProfileFormField.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/08/26.
//

import SwiftUI

struct ProfileFormField: View {
    
    let title: String
    @Binding var text: String
    var suffix: String? = nil
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.textSecondary)
            
            HStack {
                TextField(title, text: $text)
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
            .background(AppColors.foodCardBGColor)
            .cornerRadius(10)
        }
    }
}
