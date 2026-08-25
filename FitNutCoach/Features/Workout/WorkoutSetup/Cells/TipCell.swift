//
//  TipCell.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 16/08/26.
//

import SwiftUI

struct TipCell: View {

    var body: some View {
        Group {
            Text(AppTexts.workoutSetupTipLabelText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.primaryAccent)
            + Text(" \(AppTexts.workoutSetupTipBodyText)")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.textSecondary)
        }
        .lineSpacing(3)
        .multilineTextAlignment(.leading)
        .padding(.horizontal, AppSpacing.l)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryAccent.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.divider, lineWidth: 1)
        }
    }
}

#Preview {
    TipCell()
        .padding()
}
