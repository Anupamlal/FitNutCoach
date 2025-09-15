//
//  FNStepper.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/09/25.
//

import SwiftUI

struct FNStepper: View {
    
    @Binding var counter: Int
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
            .font(.system(size: 28, weight: .regular))
            .foregroundStyle(Color.textSecondary)
            .frame(width: 36, height: 36, alignment: .center)
            
            Divider()
            
            Text("\(self.counter)")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.textSecondary)
                .frame(width: 36, alignment: .center)
            
            
            Divider()
            
            Button("+") {
                self.counter += 1
                stepperCallback?()
            }
            .font(.system(size: 24, weight: .regular))
            .frame(width: 36, height: 36, alignment: .center)
            .foregroundStyle(Color.textSecondary)
        }
        .frame(height: 36)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    FNStepper(counter: .constant(0))
}
