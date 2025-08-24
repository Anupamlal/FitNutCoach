//
//  AppSpacing.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 23/08/25.
//


import SwiftUI

enum AppSpacing {
    static let s: CGFloat = 8
    static let m: CGFloat = 16
    static let l: CGFloat = 24
}

struct Card<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.s) {
            content()
        }
        .padding(AppSpacing.m)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 2, y: 1)
    }
}
