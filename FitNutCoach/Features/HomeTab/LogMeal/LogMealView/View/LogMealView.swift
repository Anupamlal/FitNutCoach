//
//  LogMealView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 13/09/25.
//

import SwiftUI
import PhotosUI

struct LogMealView: View {
    
    @StateObject var logMealViewModel: LogMealViewModel = .init()
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject var homeNavRouter: Router<HomeRouter>
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            Color.background
                .ignoresSafeArea()
            
            ScrollView(content: {
                VStack(spacing: AppSpacing.l) {
                    
                    Spacer()
                        .frame(height: AppSpacing.xs)
                    
                    Card(backgroundColor: AppColors.logMealCardBGColor, spacing: AppSpacing.l) {
                        
                        Text("\(self.logMealViewModel.dailyActivityModel?.calories.intValue() ?? 0) / \(self.logMealViewModel.dailyTotalCalories.intValue()) \(AppTexts.kcalText)")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        
                        ProgressView(
                            value:
                                self.logMealViewModel.dailyActivityModel?.calories ?? 0 < self.logMealViewModel.dailyTotalCalories ? self.logMealViewModel.dailyActivityModel?.calories : self.logMealViewModel.dailyTotalCalories, total: self.logMealViewModel.dailyTotalCalories)
                            .progressViewStyle(.linear)
                            .tint(AppColors.calorieProgressColor)
                        
                        
                        HStack {
                            
                            LogMealMacroView(macroName: AppTexts.proteinText, macroValue: "\(self.logMealViewModel.dailyActivityModel?.protein.formatToOneDecimalPlaces() ?? "")g", macroColor: AppColors.protienColor)
                            
                            Spacer()
                            
                            LogMealMacroView(macroName: AppTexts.carbsText, macroValue: "\(self.logMealViewModel.dailyActivityModel?.carbs.formatToOneDecimalPlaces() ?? "")g", macroColor: AppColors.carbsColor)
                            
                            Spacer()
                            
                            LogMealMacroView(macroName: AppTexts.fatText, macroValue: "\(self.logMealViewModel.dailyActivityModel?.fat.formatToOneDecimalPlaces() ?? "")g", macroColor: AppColors.fatColor)
                            
                        }
                        
                    }
                    
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        MealTypeView(currentMealType: mealType, foodItems: logMealViewModel.getFoodItemsFor(mealType: mealType)) {
                            self.homeNavRouter.navigate(to: .addFoodItem(selectedMealType: mealType))
                        } menuButtonCallback: { foodItem in
                            logMealViewModel.showMenuOptions = (true, foodItem, mealType)
                        }
                    }
                    
                    Spacer()
                        .padding(.bottom, 70)
                }
                .padding(.horizontal, 18)
            })
            .toolbarVisibility(.hidden, for: .tabBar)
            .withCustomBackButton(withTitle: AppTexts.logMealText)
            .onFirstAppear {
                self.logMealViewModel.setDailyActivityManager(appRootManager.dailyActivityManager, appRootManager.profileManager)
            }
            
            FNFAB(fabName: AppTexts.snapText, fabImage: "camera.fill") {
                logMealViewModel.openBottomSheetForImageSelection = true
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .padding(.bottom, 1)
        .fullScreenCover(isPresented: $logMealViewModel.openImageDetectionFlow, onDismiss: {
            logMealViewModel.selectedImage = nil
        }) {
            if let selectedImage = logMealViewModel.selectedImage {
                ImageDetectionView(selectedImage: selectedImage) { detectedFoods in
                    homeNavRouter.navigate(to: .reviewImageDetection(ReviewDetectedItemConfig(selectedItemImage: selectedImage, detectedFoodItems: detectedFoods)))
                }
            }
        }
        .sheet(isPresented: $logMealViewModel.openBottomSheetForImageSelection) {
            PictureSelectorView { selectedType in
                logMealViewModel.imageSelectionType = selectedType
                logMealViewModel.openImageSelectionView = true
            }
            .menuIndicator(.visible)
            .presentationDetents([.fraction(0.3)])
        }
        .fullScreenCover(isPresented: $logMealViewModel.openImageSelectionView) {
            FNPhotoPickerView(selectedImage: $logMealViewModel.selectedImage, sourceType: logMealViewModel.imageSelectionType == .camera ? .camera : .photoLibrary)
        }
        .onChange(of: self.logMealViewModel.selectedImage) { oldValue, newValue in
            if oldValue != newValue && newValue != nil {
                logMealViewModel.openImageDetectionFlow = true
            }
        }
        .confirmationDialog("", isPresented: $logMealViewModel.showMenuOptions.0) {
            Button(AppTexts.editText) {
                if let foodItem = logMealViewModel.showMenuOptions.1, let mealType = logMealViewModel.showMenuOptions.2 {
                    homeNavRouter.navigate(to: .reviewFoodItem(ReviewItemConfig(barcode: nil, mealType: mealType, foodItem: foodItem, isForEdit: true)))
                    DispatchQueue.main.runInMainThread({
                        logMealViewModel.showMenuOptions = (false, nil, nil)
                    })
                }
            }
            
            Button(AppTexts.deleteText, role: .destructive) {
                if let foodItem = logMealViewModel.showMenuOptions.1, let mealType = logMealViewModel.showMenuOptions.2 {
                    Task {
                        _ = await logMealViewModel.deleteFoodItem(foodItemModel: foodItem, mealType: mealType)
                        
                        await MainActor.run {
                            logMealViewModel.showMenuOptions = (false, nil, nil)
                        }
                    }
                }
            }
            
            Button(AppTexts.cancelText, role: .cancel) {
                logMealViewModel.showMenuOptions = (false, nil, nil)
            }
        }
    }
}

#Preview {
    LogMealView()
}
