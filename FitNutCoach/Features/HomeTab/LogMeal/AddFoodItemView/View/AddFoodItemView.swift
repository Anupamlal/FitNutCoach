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
    @EnvironmentObject var homeNavRouter: Router<HomeRouter>
    
    init(selectedMealType: MealType) {
        _addFoodItemViewModel = StateObject(wrappedValue: AddFoodItemViewModel(selectedMealType: selectedMealType))
    }
    
    var body: some View {
        ZStack {
            
            if !addFoodItemViewModel.searchText.isEmpty {
                
                if !addFoodItemViewModel.filteredFoodItems.isEmpty {
                    
                    SearchResultView(searchFoodItems: addFoodItemViewModel.filteredFoodItems) { selectedFoodItem in
                        addFoodItemViewModel.searchText = ""
                        addFoodItemViewModel.isSearchPresented = false
                        homeNavRouter.navigate(to: .reviewFoodItem(ReviewItemConfig(barcode: nil, mealType: addFoodItemViewModel.selectedMealType, foodItem: selectedFoodItem)))
                    }
                    
                }else {
                    Text(AppTexts.noFoodItemFoundText)
                        .foregroundStyle(.textPrimary)
                        .font(.system(size: 14, weight: .medium))
                }
                
            }else {
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
                                Text(AppTexts.noHistoryFoundText)
                                    .foregroundStyle(.textPrimary)
                                    .font(.system(size: 14, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                            }else {
                                
                                LazyVStack(alignment: .leading, spacing: 14, pinnedViews: [.sectionHeaders]) {
                                    
                                    ForEach(addFoodItemViewModel.addFoodSections, id: \.self) { currentSection in
                                        
                                        switch currentSection {
                                        case .history:
                                            Section {
                                                getFoodItemList(foodItems: self.addFoodItemViewModel.historyFoodItems)
                                                
                                            } header: {
                                                AddFoodSectionHeaderView(headerName: AppTexts.historyText)
                                            }
                                            
                                        case .frequentlyUsed:
                                            
                                            Section {
                                                getFoodItemList(foodItems: self.addFoodItemViewModel.frequentlyUsedFoodItems)
                                                
                                            } header: {
                                                AddFoodSectionHeaderView(headerName: AppTexts.frequentlyTrackedFoodsText)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    if addFoodItemViewModel.selectedFoods.count > 0 {
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Group {
                                if addFoodItemViewModel.selectedFoods.count > 1 {
                                    Text(String(format: AppTexts.someMoreFoodAddedText, "\(addFoodItemViewModel.selectedFoods.last!.name ?? "") +\(addFoodItemViewModel.selectedFoods.count - 1)"))
                                }else {
                                    Text("\(addFoodItemViewModel.selectedFoods.last!.name ?? "") \(AppTexts.addedText)")
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
                            
                            FNButton(buttonTitle: String(format: AppTexts.logForText, self.addFoodItemViewModel.selectedMealType.getDisplayName()), backgroundEnable: true, cornerRadius: 0) {
                                homeNavRouter.navigateBack()
                                Task {
                                    _ = await self.addFoodItemViewModel.logSelectedFood()
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        .padding(.bottom, 1)
        .searchable(text: $addFoodItemViewModel.searchText, isPresented: $addFoodItemViewModel.isSearchPresented, placement: .navigationBarDrawer(displayMode: .always), prompt: Text(AppTexts.searchFoodText))
        
        .withCustomBackButton(withTitle: AppTexts.addFoodItemText)
        .fullScreenCover(isPresented: $addFoodItemViewModel.openBarCodeScanner) {
            BarcodeView(mealType: self.addFoodItemViewModel.selectedMealType) {
                addFoodItemViewModel.openBarCodeScanner = false
                homeNavRouter.navigateBack()
            }
        }
        .onFirstAppear {
            self.addFoodItemViewModel.setup(appRootManager.dailyActivityManager, appRootManager.foodCatalogManager)
        }
    }
    
    @ViewBuilder
    func getFoodItemList(foodItems: [FoodItemModel]) -> some View {
        
        ForEach(foodItems, id: \.self) { foodItem in
            FoodItemView(foodItemName: foodItem.name ?? "" , brandName: foodItem.brand, servingSize: "\(foodItem.servingSize.formatToOneDecimalPlaces())\(foodItem.servingUnit ?? "g")", numberOfServing: foodItem.numberOfServing, totalCalories: "\(foodItem.calories.formatToOneDecimalPlaces()) \(AppTexts.kcalText)", isForSelection: true, measurementUnit: foodItem.measurementUnit?.rawValue) { isSelected in
                
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
