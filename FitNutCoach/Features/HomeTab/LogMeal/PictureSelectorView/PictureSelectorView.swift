//
//  PictureSelectorView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 27/09/25.
//

import SwiftUI

enum PictureSelectorType {
    case camera
    case gallery
}

struct PictureSelectorView: View {
    
    //MARK: - Variables
    @Environment(\.dismiss) var dismiss
    var selectedPictureTypeCallback: ((PictureSelectorType)->Void)
    
    //MARK: - Init Method
    init(selectedPictureTypeCallback: @escaping (PictureSelectorType) -> Void) {
        self.selectedPictureTypeCallback = selectedPictureTypeCallback
    }
    
    //MARK: - Main View
    var body: some View {
        VStack {
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                                
                Text("Select Image Source")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Button {
                    dismiss()
                    
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(.primaryAccent)
                }

                
            }
            .padding(.horizontal, 16)
            
            Spacer()
                .frame(height: 50)
            
            HStack {
                getCardFor(cardType: .camera) {
                    selectedPictureTypeCallback(.camera)
                }
                
                getCardFor(cardType: .gallery) {
                    selectedPictureTypeCallback(.gallery)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.horizontal)
    }

}

//MARK: - Functions
extension PictureSelectorView {
    
    func getCardFor(cardType: PictureSelectorType, callback: @escaping (()-> Void)) -> some View {
        Button {
            callback()
            dismiss()
            
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(AppColors.logMealCardBGColor)
                .frame(height: 90)
                .overlay {
                    VStack {
                        
                        if let image = getCardNameAndImageName(cardType: cardType).1 {
                            
                            Image(systemName: image)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(Color.primaryAccent)
                        }
                        
                        Text(getCardNameAndImageName(cardType: cardType).0)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.primaryAccent)
                        
                    }
                }
        }
    }
    
    func getCardNameAndImageName(cardType: PictureSelectorType) -> (String, String?) {
        
        switch cardType {
        case .camera:
            return ("Camera", "camera.fill")
                    
        case .gallery:
            return ("Gallery", "photo.fill")
            
        }
    }
}

#Preview {
    PictureSelectorView { _ in
        
    }
}

