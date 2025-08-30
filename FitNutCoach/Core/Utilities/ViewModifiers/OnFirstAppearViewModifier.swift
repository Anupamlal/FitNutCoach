//
//  OnFirstAppearViewModifier.swift
//  PennyPlanner
//
//  Created by Anupam Kumar Lal on 28/12/24.
//

import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var isAppearanceDone = false
    var onFirstAppear: (() -> Void)? = nil
    
    func body(content: Content) -> some View {
        
        content
            .onAppear {
                if !isAppearanceDone {
                    if onFirstAppear != nil {
                        onFirstAppear!()
                    }
                    isAppearanceDone = true
                }
            }
    }
}

extension View {
    public func onFirstAppear(perform action: (() -> Void)? = nil) -> some View {
        self
            .modifier(OnFirstAppearViewModifier(onFirstAppear: {
                if action != nil {
                    action!()
                }
            }))
    }
}
