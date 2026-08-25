//
//  WorkoutIntroView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 15/08/26.
//

import SwiftUI

struct WorkoutIntroView: View {

    let onLetsBuild: () -> Void
    let onMaybeLater: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
                .ignoresSafeArea()

            WorkoutIntroWaveBackground()
                .ignoresSafeArea(edges: .bottom)

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 72)

                iconBadge

                Spacer()
                    .frame(height: AppSpacing.xl)

                Text(AppTexts.workoutIntroTitleText)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)

                Spacer()
                    .frame(height: AppSpacing.l)

                Text(AppTexts.workoutIntroSubtitleText)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)

                Spacer()
                    .frame(height: AppSpacing.xl)

                VStack(spacing: AppSpacing.l) {
                    WorkoutIntroFeatureRow(
                        iconName: "person.fill",
                        title: AppTexts.workoutIntroFeaturePersonalizedText
                    )
                    WorkoutIntroFeatureRow(
                        iconName: "hand.thumbsup.fill",
                        title: AppTexts.workoutIntroFeatureBalancedText
                    )
                    WorkoutIntroFeatureRow(
                        iconName: "stopwatch.fill",
                        title: AppTexts.workoutIntroFeatureEasyText
                    )
                }
                .padding(.horizontal, 40)

                Spacer()

                VStack(spacing: AppSpacing.l) {
                    FNButton(
                        buttonTitle: AppTexts.workoutIntroLetsBuildText,
                        backgroundEnable: true,
                        buttonAction: onLetsBuild
                    )

                    Button(action: onMaybeLater) {
                        Text(AppTexts.workoutIntroMaybeLaterText)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Color.primaryAccent)
                    }
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, 40)
            }
        }
    }

    private var iconBadge: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.primaryAccent.opacity(0.12))
            .frame(width: 88, height: 88)
            .overlay {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(Color.primaryAccent)
            }
    }
}

private struct WorkoutIntroWaveBackground: View {
    var body: some View {
        GeometryReader { geometry in
            WaveShape()
                .fill(Color.primaryAccent.opacity(0.08))
                .frame(height: geometry.size.height * 0.42)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

private struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waveHeight = rect.height * 0.18

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: waveHeight))

        path.addCurve(
            to: CGPoint(x: rect.maxX, y: waveHeight * 1.2),
            control1: CGPoint(x: rect.width * 0.35, y: 0),
            control2: CGPoint(x: rect.width * 0.65, y: waveHeight * 2.2)
        )

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

#Preview {
    WorkoutIntroView(onLetsBuild: {}, onMaybeLater: {})
}
