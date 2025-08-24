//
//  ProgressRingsView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

enum ProgressRingType {
    case calories
    case steps
    case waterIntake
}

struct ProgressRingsView: View {
    var body: some View {
        Card {
            HStack() {
                
                ProgressRingCellView(currentProgressValue: 1350, totalValue: 2000, currentRingType: .calories)
                Spacer()

                ProgressRingCellView(currentProgressValue: 7500, totalValue: 10000, currentRingType: .steps)
                Spacer()

                ProgressRingCellView(currentProgressValue: 1.0, totalValue: 4.0, currentRingType: .waterIntake)
                                
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ProgressRingsView()
}
