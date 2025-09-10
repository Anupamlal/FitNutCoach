//
//  FNActivityIndicator.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 13/07/24.
//

import SwiftUI

struct FNActivityIndicator: View {
    

    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.3))
            .ignoresSafeArea()
            .overlay {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.white)
                    
                    ProgressView()
                        .controlSize(.large)
                        .tint(Color.black)
                }
            }
    }
}


