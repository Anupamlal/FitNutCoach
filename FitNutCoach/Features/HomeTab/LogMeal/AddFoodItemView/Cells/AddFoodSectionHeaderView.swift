//
//  AddFoodSectionHeaderView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 14/09/25.
//

import SwiftUI

struct AddFoodSectionHeaderView: View {
    
    let headerName: String
    
    var body: some View {
        HStack {
            Text(headerName)
                .foregroundStyle(Color.textPrimary)
                .font(.system(size: 20, weight: .semibold))
            Spacer()
        }
        .frame(height: 40)
        .background(Color.white)
    }
}

#Preview {
    AddFoodSectionHeaderView(headerName: "")
}
