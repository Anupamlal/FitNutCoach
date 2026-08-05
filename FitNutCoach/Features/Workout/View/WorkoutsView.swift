//
//  WorkoutsView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 24/08/25.
//

import SwiftUI

struct WorkoutsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    Image("workouts_1")
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.width*2/3)
                        .overlay {
                            Rectangle()
                                .foregroundStyle(Color.black.opacity(0.7))
                        }
                }
                .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.m) {
                    Text("Day 12")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.white)
                    
                    Text("Upper Body Strength")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                        .frame(height: 45)
                    
                    Card(borderEnable: true) {
                        HStack(alignment: .center) {
                            
                            Spacer()
                            
                            VStack {
                                Text("30")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                Text("mins")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            
                            Spacer()
                            
                            Divider()
                            
                            Spacer()
                            
                            VStack {
                                Text("220")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                Text("kcal")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            
                            Spacer()
                            
                            Divider()
                            
                            Spacer()
                            
                            VStack {
                                Text("6")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                Text("Excercises")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color.textSecondary)
                            }
                            .frame(maxWidth: .greatestFiniteMagnitude)
                            
                            Spacer()
                            
                        }
                    }
                    .frame(height: 100)
                    
                    
                    if let equipments = equipmentCategories[.chest]?.equipments {
                        Card(borderEnable: true) {
                            VStack(alignment: .leading, spacing: AppSpacing.l) {
                                Text("Equipments needed")
                                    .font(.system(size: 18, weight: .semibold))
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(equipments) { equipment in
                                            Text(equipment.name)
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 8)
                                                .background(equipment.color)
                                                .foregroundColor(.white)
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 100)
                    }
                    
                    FNButton(buttonTitle: "Start Workout", backgroundEnable: true) {
                        
                    }
                    
                    FNButton(buttonTitle: "Change Workout", backgroundEnable: false) {
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal)
                
            }
        }
    }
}

#Preview {
    WorkoutsView()
}
