//
//  FNNavigationButton.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 11/07/24.
//

import SwiftUI

struct FNNavigationButton<Destination: View>: View {
    
    var buttonTitle: String
    var backgroundEnable: Bool = true
    var destination: (() -> Destination)?
    var backgroundColor: Color = Color.primaryAccent
    var isShadowEnable: Bool = false

    init(buttonTitle: String, backgroundEnable: Bool, destination: (() -> Destination)?, backgroundColor: Color, isShadowEnable: Bool) {
        self.buttonTitle = buttonTitle
        self.backgroundEnable = backgroundEnable
        self.destination = destination
        self.backgroundColor = backgroundColor
        self.isShadowEnable = isShadowEnable
    }
    
    init(buttonTitle: String, backgroundEnable: Bool, destination: (() -> Destination)?) {
        self.buttonTitle = buttonTitle
        self.backgroundEnable = backgroundEnable
        self.destination = destination
    }
    
    var body: some View {
        
        NavigationLink {
            
            if let destination = destination {
                destination()
            }
            
        } label: {
            
            if (backgroundEnable) {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(
                        backgroundColor
                    )
                    .overlay {
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(backgroundColor == Color.primaryAccent ? .white : Color.primaryAccent)
                    }
            }else {
                Text(buttonTitle)
                    .font(.system(size: 16, weight: .semibold))
            }
            
        }
        .frame(height: 48)
        .shadow(radius: isShadowEnable ? 10 : 0, y: isShadowEnable ? 4 : 0)
    }
}
