//
//  AddFoodItemView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 13/09/25.
//

import SwiftUI

struct AddFoodItemView: View {
    
    @State var searchText: String = ""
    var allFoodItems: [String] = ["Pasta", "Maggie", "Dal", "Biryani", "Roti", "Naan", "Bread", "Bun", "Burger", "Pizza"]
    
    @State var selectedFoods = [String]()
    @State var openBarCodeScanner = false
    
    struct TableKey: Hashable {
        let section: Int
        let index: Int
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.m) {
                    
                    if searchText.isEmpty {
                        
                        Button {
                            openBarCodeScanner = true
                            
                        } label: {
                            Card(backgroundColor: AppColors.logMealCardBGColor) {
                                HStack() {
                                    VStack(alignment: .leading, spacing: AppSpacing.s){
                                        Text(AppTexts.scanABarCodeText)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color.textPrimary)
                                        
                                        Text(AppTexts.foodViaBarcodeText)
                                            .font(.system(size: 14, weight: .regular))
                                            .foregroundColor(Color.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "barcode.viewfinder")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color.primaryAccent)
                                    
                                }
                            }
                        }
                        .padding(.top, AppSpacing.s)
                        
                        Spacer()
                            .frame(height: 2)
                    }
                                    
                    LazyVStack(alignment: .leading, spacing: 14, pinnedViews: [.sectionHeaders]) {
                        
                        Section {
                            ForEach(allFoodItems.indices.map{TableKey(section: 0, index: $0)}, id: \.self) { pair in
                                HStack {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(allFoodItems[pair.index])
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(Color.textPrimary)
                                        
                                        Text("40g")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Color.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("300 kcal")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color.textSecondary)
                                        .padding(.trailing, 8)
                                    
                                    Button {
                                        withAnimation(.easeInOut) {
                                            selectedFoods.append(allFoodItems[pair.index])
                                        }
                                        
                                    } label: {
                                        Image(systemName: "plus.app")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(Color.primaryAccent)
                                    }

                                }
                            }
                        } header: {
                            
                            HStack {
                                Text("History")
                                    .foregroundStyle(Color.textPrimary)
                                    .font(.system(size: 20, weight: .semibold))
                                Spacer()
                            }
                            .frame(height: 40)
                            .background(Color.white)
                        }
                        
                        Spacer()
                            .frame(height: 0)
                        
                        Section {
                            ForEach(allFoodItems.indices.map{TableKey(section: 1, index: $0)}, id: \.self) { pair in
                                HStack {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(allFoodItems[pair.index])
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(Color.textPrimary)
                                        
                                        Text("40g")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Color.textSecondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("300 kcal")
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color.textSecondary)
                                        .padding(.trailing, 8)
                                    
                                    Button {
                                        
                                        
                                    } label: {
                                        Image(systemName: "plus.app")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 25, height: 25)
                                            .foregroundStyle(Color.primaryAccent)
                                    }

                                }
                            }
                        } header: {
                            
                            HStack {
                                Text("Frequently Tracked Foods")
                                    .foregroundStyle(Color.textPrimary)
                                    .font(.system(size: 20, weight: .semibold))
                                Spacer()
                            }
                            .frame(height: 40)
                            .background(Color.white)
                        }
                        
                        
                    }
                    
                }
                .searchable(text: $searchText, prompt: Text("Search food item"))
                .padding(.horizontal, 20)
            }
            
            if selectedFoods.count > 0 {
                FNButton(buttonTitle: "Add Selected Foods", backgroundEnable: true) {
                    
                }
                .padding(.horizontal, 20)

            }

        }
        .padding(.bottom, 20)
        .withCustomBackButton(withTitle: "Add Food Item")
        .fullScreenCover(isPresented: $openBarCodeScanner) {
            BarcodeView(isPresented: $openBarCodeScanner)
        }
        
    }
}

#Preview {
    NavigationStack {
        AddFoodItemView()

    }
}
