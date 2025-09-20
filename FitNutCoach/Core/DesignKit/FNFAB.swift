//
//  FNFAB.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 19/09/25.
//

import SwiftUI

struct FNFAB: View {
    
    var fabName: String
    var fabImage: String
    var fabCallback:(()->Void)?
    
    var body: some View {
        Button(action: {
            fabCallback?()
            
        }) {
            Label(fabName, systemImage: fabImage)
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color.primaryAccent)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .shadow(radius: 4)
        }
    }
}

#Preview {
    FNFAB(fabName: AppTexts.snapText, fabImage: "camera.fill")
}
