//
//  SelectMealTypeBottomSheet.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 28/09/25.
//

import SwiftUI

struct SelectMealTypeBottomSheet: View {
    
    @Binding var selectedMealType: MealType
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 25)
            
            Text(AppTexts.selectMealTypeText)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .padding(.top, AppSpacing.m)
            
            Spacer()
                .frame(height: 10)
            
            Text(AppTexts.pleaseSelectTheMealTypeText)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.textSecondary)
            
            Spacer()
                .frame(height: 20)
            
            VStack(spacing: 15) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    Button {
                        selectedMealType = mealType
                        dismiss()
                        
                    } label: {
                        Card(backgroundColor: Color.white, borderEnable: true) {
                            HStack {
                                Image(systemName: getIcon(mealType: mealType))
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.primaryAccent)
                                    .padding(.trailing, 5)
                                
                                Text(mealType.getDisplayName())
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(Color.textPrimary)
                                
                                Spacer()
                                
                                Image(systemName: selectedMealType == mealType ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(Color.primaryAccent)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.m)
            
            Spacer()
        }
        .padding(.bottom, AppSpacing.m)
    }
    
    func getIcon(mealType: MealType) -> String {
        switch mealType {
        case .breakfast:
            return "sunrise.fill"
            
        case .lunch:
            return "sun.max"
            
        case .dinner:
            return "moon.fill"
            
        case .snacks:
            return "cup.and.saucer.fill"
        }
    }
}

#Preview {
    SelectMealTypeBottomSheet(selectedMealType: .constant(.breakfast))
}
