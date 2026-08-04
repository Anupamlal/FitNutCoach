//
//  NudgeDetailCellView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 11/10/25.
//

import SwiftUI

struct NudgeDetailCellView: View {
    
    let nudge: NudgeModel
    var showCompletedTimestamp: Bool = false
    let onMarkCompleted: () -> Void
    let onDismiss: () -> Void
    let onAction: () -> Void
    
    var body: some View {
        Card(backgroundColor: .white) {
            VStack(alignment: .leading, spacing: AppSpacing.s) {
                HStack(alignment: .top) {
                    Text(nudge.category.iconEmoji())
                        .font(.system(size: 30, weight: .bold))
                    
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        HStack {
                            Text(nudge.title)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            if nudge.status == .active {
                                Text(nudge.priority.displayName())
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(Color(nudge.priority.color))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background {
                                        Capsule()
                                            .fill(Color(nudge.priority.color).opacity(0.12))
                                    }
                            }
                        }
                        
                        Text(nudge.message)
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.textSecondary)
                        
                        if showCompletedTimestamp, let completedAt = nudge.completedAt {
                            Text(String(format: AppTexts.nudgeGeneratedAtText, completedAt.getTime()))
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.textSecondary)
                        } else if nudge.status == .active {
                            Text(String(format: AppTexts.nudgeGeneratedAtText, nudge.createdAt.getTime()))
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                
                if nudge.status == .active {
                    HStack {
                        if let actionTitle = nudge.actionType.actionButtonTitle() {
                            FNButton(buttonTitle: actionTitle, backgroundEnable: true, buttonHeight: 40) {
                                onAction()
                            }
                        }
                        
                        FNButton(buttonTitle: AppTexts.nudgeMarkCompletedText, backgroundEnable: false, buttonHeight: 40) {
                            onMarkCompleted()
                        }
                        
                        FNButton(buttonTitle: AppTexts.nudgeDismissText, backgroundEnable: false, buttonHeight: 40) {
                            onDismiss()
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

#Preview {
    NudgeDetailCellView(
        nudge: NudgeModel(
            ruleId: "preview",
            title: "Hydration Boost",
            message: "Drink a glass of water to stay hydrated.",
            category: .hydration,
            priority: .high
        ),
        onMarkCompleted: {},
        onDismiss: {},
        onAction: {}
    )
}
