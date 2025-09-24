//
//  FNStepper.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/09/25.
//

import SwiftUI

struct FNStepper: View {
    
    @Binding var counter: Int
    var sizeOfEachVertical: CGFloat = 36
    var isEnabled: Bool = true
    var stepperCallback: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            Button("-") {
                if counter > 1 {
                    counter -= 1
                    stepperCallback?()
                }
            }
            .disabled(self.counter == 1)
            .font(.system(size: getPlusMinusFontSize(), weight: .regular))
            .foregroundStyle(Color.textSecondary)
            .frame(width: sizeOfEachVertical, height: sizeOfEachVertical, alignment: .center)
            
            Divider()
            
            Text("\(self.counter)")
                .font(.system(size: getCounterFontSize(), weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .frame(width: sizeOfEachVertical, alignment: .center)
            
            
            Divider()
            
            Button("+") {
                self.counter += 1
                stepperCallback?()
            }
            .font(.system(size: getPlusMinusFontSize(), weight: .regular))
            .frame(width: sizeOfEachVertical, height: sizeOfEachVertical, alignment: .center)
            .foregroundStyle(Color.textSecondary)
            .disabled(!isEnabled)
        }
        .frame(height: sizeOfEachVertical)
        .background(Color(.systemGray6))
        .cornerRadius(getCornerRadius())
    }
    
    private func getCornerRadius() -> CGFloat {
        return sizeOfEachVertical * (10/36)
    }
    
    private func getPlusMinusFontSize() -> CGFloat {
        return sizeOfEachVertical * (28/36)
    }
    
    private func getCounterFontSize() -> CGFloat {
        return sizeOfEachVertical * (16/36)
    }
}

#Preview {
    FNStepper(counter: .constant(1))
}
