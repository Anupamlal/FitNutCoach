//
//  AppSpacing.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 23/08/25.
//


import SwiftUI

enum AppSpacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 12
    static let l: CGFloat = 16
    static let xl: CGFloat = 24
}

struct Card<Content: View>: View {
    let content: () -> Content
    let shadowEnable: Bool
    let backgroundColor: Color
    let borderEnable: Bool
    init(shadowEnable: Bool = false, backgroundColor: Color = .white, borderEnable: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.shadowEnable = shadowEnable
        self.backgroundColor = backgroundColor
        self.borderEnable = borderEnable
    }
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.s) {
            content()
        }
        .padding(AppSpacing.l)
        .background(backgroundColor)
        .cornerRadius(16)
        .shadow(radius: shadowEnable ? 2 : 0, y: shadowEnable ? 1 : 0)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderEnable ? Color.gray.opacity(0.2) : Color.clear, lineWidth: borderEnable ? 1 : 0)
        )
    }
}
