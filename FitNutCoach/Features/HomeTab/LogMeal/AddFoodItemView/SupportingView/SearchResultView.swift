//
//  SearchResultView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 19/09/25.
//

import SwiftUI

struct SearchResultView: View {
    
    let searchFoodItems: [FoodItemModel]
    var searchResultTapCallback: ((FoodItemModel) -> Void)?
    
    var body: some View {
        List(searchFoodItems, id: \.self) { foodItem in
            Button {
                if let searchResultTapCallback = searchResultTapCallback {
                    searchResultTapCallback(foodItem)
                }
            } label: {
                HStack {
                    Text(foodItem.name ?? "")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .renderingMode(.template)
                        .foregroundStyle(Color.primaryAccent)
                }
            }

        }
        .listStyle(PlainListStyle())
    }
}
