//
//  ProgressRing.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//


import SwiftUI

/// Reusable circular progress ring.
/// - value: current amount (e.g., 1.4)
/// - total: goal/target (e.g., 3.0)
/// - ringWidth: stroke width
/// - color: main progress color
/// - trackColor: background ring color
/// - showOverTarget: if true, clamp visual to 100% but switch color on overflow
struct ProgressRing: View {
    var value: Double
    var total: Double
    var ringWidth: CGFloat = 10
    var color: Color = Color.blue
    var trackColor: Color = Color.blue.opacity(0.15)
    var overTargetColor: Color = Color.green
    var clockwise: Bool = true
    var animation: Animation = .easeOut(duration: 0.6)
    var showOverTarget: Bool = true

    @State private var animatedProgress: CGFloat = 0

    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(min(value / total, 1.0))
    }

    private var isOverTarget: Bool {
        total > 0 && value > total
    }

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let radius = size / 2

            ZStack {
                // Track
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                    .foregroundStyle(trackColor)

                // Progress arc
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .rotation(.degrees(-90))
                    .stroke(
                        (isOverTarget && showOverTarget ? overTargetColor : color),
                        style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)
                    )
                    .animation(animation, value: animatedProgress)

                // Optional overage indicator (small dot at end)
                if isOverTarget && showOverTarget {
                    Circle()
                        .fill(overTargetColor)
                        .frame(width: ringWidth * 0.5, height: ringWidth * 0.5)
                        .offset(y: -radius + ringWidth/2)
                        .rotationEffect(.degrees(Double(animatedProgress) * 360))
                        .animation(animation, value: animatedProgress)
                }
            }
            .onAppear {
                animatedProgress = progress
            }
            .onChange(of: value, { oldVal, newValue in
                animatedProgress = progress
            })
            .onChange(of: total, { oldVal, newValue in
                animatedProgress = progress
            })
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
