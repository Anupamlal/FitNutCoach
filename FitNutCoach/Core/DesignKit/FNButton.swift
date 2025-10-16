//
//  FNButton.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct FNButton: View {
    
    var buttonTitle: String
    var backgroundEnable: Bool
    var backgroundColor: Color = .primaryAccent
    var isEnabled: Bool = true
    var isShadowEnable: Bool = false
    var buttonIconName: String? = nil
    var cornerRadius: CGFloat = 14
    var buttonHeight: CGFloat = 48
    var buttonAction:(()->())
    
    var body: some View {
        
        Button(action: {
            if isEnabled {
                buttonAction()
            }
            
        }, label: {
            
            if (backgroundEnable) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(
                        isEnabled ? backgroundColor : backgroundColor.opacity(0.5)
                    )
                    .overlay {
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(backgroundColor == Color.primaryAccent ? .white : Color.primaryAccent)
                    }
            }else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isEnabled ? backgroundColor : backgroundColor.opacity(0.5))
                    .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 14)))
                    .overlay {
                        HStack {
                            
                            if let buttonIconName = buttonIconName {
                                Image(systemName: buttonIconName)
                                    .renderingMode(.template)
                                    .foregroundStyle(backgroundColor)
                            }
                            
                            Text(buttonTitle)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(isEnabled ? backgroundColor : backgroundColor.opacity(0.5))
                        }
                    }
            }
            
        })
        .disabled(!isEnabled)
        .frame(height: buttonHeight)
        .shadow(radius: isShadowEnable ? 10 : 0, y: isShadowEnable ? 4 : 0)
    }
}

#Preview {
    FNButton(buttonTitle: "Login", backgroundEnable: false, buttonAction: {
        
    })
}
