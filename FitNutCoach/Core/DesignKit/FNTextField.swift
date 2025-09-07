////
////  FNTextField.swift
////  FitNutCoach
////
////  Created by Anupam Kumar Lal on 07/09/25.
////
//
//import SwiftUI
//
//struct FNTextField: View {
//    
//    @Binding var textFieldBinding:String
//    var placeholder:String
//    var keyboardType:UIKeyboardType?
//    var borderColor: Color = .textFieldBorderColor
//    var onEditingChanged: ((Bool) -> Void)?
//    var showCharacterCounter: Bool = false
//    var maxCharCount = 25
//    
//    var body: some View {
//        
//        HStack {
//            TextField(placeholder, text: $textFieldBinding) {(status) in
//                if let onEditingChanged = onEditingChanged{
//                    onEditingChanged(status)
//                }
//            }
//            
//            if showCharacterCounter{
//                Text("\(maxCharCount - textFieldBinding.count)")
//                    .font(.regularFont(ofSize: .regular1))
//                    .foregroundStyle(Color.light20)
//            }
//        }
//        .padding()
//        .font(.regularFont(ofSize: .regular1))
//        .tint(Color.appThemeColor)
//        .keyboardType(keyboardType == nil ? .default : keyboardType!)
//        .submitLabel(.done)
//        .frame(height: 56)
//        .autocorrectionDisabled()
//        .contentShape(RoundedRectangle(cornerRadius: 16))
//        .overlay(
//            RoundedRectangle(cornerRadius: 16)
//                .stroke(borderColor, lineWidth: 1)
//        )
//    }
//}
//
//#Preview {
//    FNTextField()
//}
