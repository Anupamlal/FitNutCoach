//
//  QuickRecipesView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct QuickRecipesView: View {
    var body: some View {
        Card {
            HStack(spacing: AppSpacing.s) {
                Image("paneerDish")
                    .resizable()
                    .frame(width: 70, height: 70)
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Paneer Bowl")
                        .font(.system(size: 15, weight: .semibold))
                    
                    Text("420 kcal")
                        .font(.system(size: 13, weight: .regular))
                    
                    Text("25g Protien")
                        .font(.system(size: 13, weight: .regular))
                }
            }
        }
    }
}

#Preview {
    QuickRecipesView()
}
