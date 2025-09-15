//
//  FNKeyValueView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/09/25.
//

import SwiftUI

struct FNKeyValueView: View {
    
    let keyName: String
    let valueName: String
    let height: CGFloat?
    let isExpandable: Bool
    var valueTapCallback: (() -> Void)?
    
    init(keyName: String, valueName: String, height: CGFloat? = 48, isExpandable: Bool = false, valueTapCallback: (() -> Void)? = nil) {
        self.keyName = keyName
        self.valueName = valueName
        self.height = height
        self.isExpandable = isExpandable
        self.valueTapCallback = valueTapCallback
    }
    
    var body: some View {
        HStack {
            Text(keyName)
                .foregroundStyle(Color.textPrimary)
                .font(.system(size: 15, weight: .semibold))
            
            Spacer()
            
            if isExpandable {
                Group {
                    Text(valueName)
                        .foregroundStyle(Color.textSecondary)
                        .font(.system(size: 15, weight: .regular))
                    
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color.primaryAccent)
                }
                .onTapGesture {
                    self.valueTapCallback?()
                }
                
            }else {
                Text(valueName)
                    .foregroundStyle(Color.textSecondary)
                    .font(.system(size: 15, weight: .regular))
            }
            
        }
        .frame(height: self.height)
    }
}

#Preview {
    FNKeyValueView(keyName: "Meal", valueName: "nn")
}
