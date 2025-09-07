//
//  CustomBackButtonModifier.swift
//  PennyPlanner
//
//  Created by Anupam Kumar Lal on 20/07/24.
//

import SwiftUI

enum BackButtonType {
    case close
    case back
}

struct CustomBackButtonModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    var navigationTitle: String
    var navigationSubTitle: String? = nil
    @Binding var isBackbuttonActive: Bool
    var showBackButton = true
    var backButtonTint: Color = .black
    var backButtonType: BackButtonType = .back

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(navigationTitle)
                            .font(.system(.title3))
                            .foregroundStyle(backButtonTint)
                        
                        if let navigationSubTitle = navigationSubTitle {
                            Text(navigationSubTitle)
                                .font(.system(.subheadline))
                                .foregroundStyle(backButtonTint)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    if showBackButton {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: backButtonType == .back ? "arrow.backward" :  "xmark")
                                    .renderingMode(.template)
                                    .bold()
                                    .tint(backButtonTint)
                            }
                        }
                        .disabled(!isBackbuttonActive)
                    }
                }
            }
            .background {
                AttachPopGestureView(gesture: $interactivePopGestureRecognizer)
            }
    }
    
    @State private var interactivePopGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.edges = UIRectEdge.left
        gesture.isEnabled = true
        return gesture
    }()
}

extension View {
    func withCustomBackButton(withTitle title: String, backButtonTint: Color = .black, backButtonType: BackButtonType = .back) -> some View {
        self.modifier(CustomBackButtonModifier(navigationTitle: title, isBackbuttonActive: .constant(true), backButtonTint: backButtonTint, backButtonType: backButtonType))
    }
    
    func withCustomBackButton(withTitle title: String, backButtonTint: Color = .black, isBackButtonActive: Binding<Bool>) -> some View {
        self.modifier(CustomBackButtonModifier(navigationTitle: title, isBackbuttonActive: isBackButtonActive, backButtonTint: backButtonTint))
    }
    
    func withCustomBackButton(withTitle title: String, subTitle: String, backButtonTint: Color = .black, isBackButtonActive: Binding<Bool>) -> some View {
        self.modifier(CustomBackButtonModifier(navigationTitle: title, navigationSubTitle: subTitle, isBackbuttonActive: isBackButtonActive, backButtonTint: backButtonTint))
    }
    
    func withoutBackButton(withTitle title: String, titleTint: Color = .black) -> some View {
        self.modifier(CustomBackButtonModifier(navigationTitle: title, isBackbuttonActive: .constant(false), showBackButton: false, backButtonTint: titleTint))
    }
    
}

extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }.first { $0 is UIViewController } as? UIViewController
    }
}

fileprivate extension UINavigationController {
    func addInteractivePopGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureSelector = interactivePopGestureRecognizer?.value(forKey: "targets") else { return }
        
        gesture.setValue(gestureSelector, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
}

struct AttachPopGestureView: UIViewRepresentable {
    @Binding var gesture: UIScreenEdgePanGestureRecognizer
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            if let parentVC = uiView.parentViewController {
                if let navigationController = parentVC.navigationController {
                    
                    // To prevent duplication
                    guard !(navigationController.view.gestureRecognizers?
                        .contains(where: {$0.name == gesture.name}) ?? true) else { return }
                
                    navigationController.addInteractivePopGesture(gesture)
                }
            }
        }
    }
}
