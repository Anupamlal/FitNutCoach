//
//  AddFoodItemView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 13/09/25.
//

import SwiftUI

struct AddFoodItemView: View {
    
    @StateObject private var addFoodItemViewModel: AddFoodItemViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    @Environment(\.dismiss) var dismiss
    
    init(selectedMealType: MealType) {
        _addFoodItemViewModel = StateObject(wrappedValue: AddFoodItemViewModel(selectedMealType: selectedMealType))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.m) {
                    
                    if addFoodItemViewModel.searchText.isEmpty {
                        
                        BarcodeSnapView {
                            self.addFoodItemViewModel.openBarCodeScanner = true
                        }
                        
                        Spacer()
                            .frame(height: 2)
                    }
                    
                    if addFoodItemViewModel.addFoodSections.isEmpty {
                        Text("No food item found")
                            .foregroundStyle(.textPrimary)
                            .font(.system(size: 14, weight: .medium))
                        
                    }else {
                        
                        LazyVStack(alignment: .leading, spacing: 14, pinnedViews: [.sectionHeaders]) {
                            
                            ForEach(addFoodItemViewModel.addFoodSections, id: \.self) { currentSection in
                                
                                switch currentSection {
                                case .history:
                                    Section {
                                        getFoodItemList(foodItems: self.addFoodItemViewModel.filteredHistoryFoods)
                                        
                                    } header: {
                                        AddFoodSectionHeaderView(headerName: AppTexts.historyText)
                                    }
                                    
                                case .frequentlyUsed:
                                    
                                    Section {
                                        getFoodItemList(foodItems: self.addFoodItemViewModel.filteredFrequentlyUsedFoods)
                                        
                                    } header: {
                                        AddFoodSectionHeaderView(headerName: AppTexts.frequentlyTrackedFoodsText)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
                .searchable(text: $addFoodItemViewModel.searchText, prompt: Text(AppTexts.searchFoodText))
                .padding(.horizontal, 20)
            }
            
            if addFoodItemViewModel.selectedFoods.count > 0 {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Group {
                        if addFoodItemViewModel.selectedFoods.count > 1 {
                            Text("\(addFoodItemViewModel.selectedFoods.last!.name ?? "") +\(addFoodItemViewModel.selectedFoods.count - 1) more food added")
                        }else {
                            Text("\(addFoodItemViewModel.selectedFoods.last!.name ?? "") added")
                        }
                    }
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.textPrimary)
                    .background {
                        AppColors.logMealCardBGColor
                    }
                    
                    FNButton(buttonTitle: "Log For \(self.addFoodItemViewModel.selectedMealType.getDisplayName())", backgroundEnable: true, cornerRadius: 0) {
                        dismiss()
                        Task {
                            _ = await self.addFoodItemViewModel.logSelectedFood()
                        }
                    }
                    
                }
            }

        }
        .padding(.bottom, 1)
        .withCustomBackButton(withTitle: AppTexts.addFoodItemText)
        .fullScreenCover(isPresented: $addFoodItemViewModel.openBarCodeScanner) {
            BarcodeView(mealType: self.addFoodItemViewModel.selectedMealType, isPresented: $addFoodItemViewModel.openBarCodeScanner)
        }
        .onFirstAppear {
            self.addFoodItemViewModel.setup(appRootManager.foodCatalogManager, appRootManager.dailyActivityManager)
        }
        
    }
    
    @ViewBuilder
    func getFoodItemList(foodItems: [FoodItemModel]) -> some View {
        
        ForEach(foodItems, id: \.id) { foodItem in
            FoodItemView(foodItemName: foodItem.name ?? "" , brandName: foodItem.brand, servingSize: "\(foodItem.servingSize.formatToOneDecimalPlaces())\(foodItem.servingUnit ?? "g")", numberOfServing: foodItem.numberOfServing, totalCalories: "\(foodItem.calories.formatToOneDecimalPlaces()) \(AppTexts.kcalText)", isForSelection: true) { isSelected in
                
                withAnimation {
                    if isSelected {
                        addFoodItemViewModel.selectedFoods.append(foodItem)
                    }else {
                        addFoodItemViewModel.selectedFoods.remove(at: addFoodItemViewModel.selectedFoods.firstIndex(of: foodItem)!)
                    }
                }
                
            }
            .padding(.bottom, 5)
        }
    }
}

#Preview {
    NavigationStack {
        AddFoodItemView(selectedMealType: .breakfast)

    }
}
