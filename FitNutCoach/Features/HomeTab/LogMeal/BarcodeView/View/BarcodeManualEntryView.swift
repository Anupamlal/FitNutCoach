//
//  BarcodeManualEntryView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 07/09/25.
//

import SwiftUI

struct BarcodeManualEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var code: String
    var onDone: (() -> Void)?

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
                .frame(height: 50)
            
            TextField(AppTexts.enterBarcodeText, text: $code)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            
            FNButton(buttonTitle: AppTexts.confirmText, backgroundEnable: true, isEnabled: !(code.trimmingCharacters(in: .whitespaces).isEmpty)) {
                self.dismiss()
                onDone?()
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        
    }
}

#Preview {
    BarcodeManualEntryView(code: .constant(""))
}
