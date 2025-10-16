//
//  AllNudgesView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/10/25.
//

import SwiftUI

struct AllNudgesView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    Card(backgroundColor: .white) {
                        HStack(spacing: AppSpacing.s) {
                            Text("💡")
                                .font(.system(size: 35, weight: .bold))
                                
                            VStack(alignment: .leading, spacing: AppSpacing.s) {
                                Text("3 Smart Nudges Today")
                                    .foregroundStyle(Color.textPrimary)
                                    .font(.system(size: 18, weight: .semibold))
                                
                                Text("2 Completed | 1 Pending")
                                    .foregroundStyle(Color.textSecondary)
                                    .font(.system(size: 16, weight: .regular))
                                
                            }
                            Spacer()
                        }
                        
                    }
                    .padding(.top, 12)
                    
                    NudgeDetailCellView()
                    
                    NudgeDetailCellView()
                    
                    NudgeDetailCellView()
                    
                    NudgeDetailCellView()
                    
                }
                .padding(.horizontal, 20)
            }
        }
        .withCustomBackButton(withTitle: "Nudges")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "gearshape")
                        .renderingMode(.template)
                        .foregroundStyle(Color.primaryAccent)
                }

            }
        }
    }
}

#Preview {
    NavigationStack {
        AllNudgesView()
    }
}
