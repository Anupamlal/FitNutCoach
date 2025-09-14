//
//  BarcodeView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 05/09/25.
//

import SwiftUI

struct BarcodeView: View {
    
    @StateObject private var barcodeViewModel: BarcodeViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    @Binding var isPresented: Bool
    
    init(mealType: MealType, isPresented: Binding<Bool>) {
        _barcodeViewModel = StateObject(wrappedValue: BarcodeViewModel(mealType: mealType))
        _isPresented = isPresented
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                ZStack{
                    
                    BarcodeScannerView(isSessionRunning: $barcodeViewModel.isSessionRunning, scannedCodeCallback: { code in
                        barcodeViewModel.barcodeValue = code
                        barcodeViewModel.isSessionRunning = false
                        
                        DispatchQueue.main.async {
                            self.barcodeViewModel.isBarcodeDetected = true
                        }
                    })
                    .ignoresSafeArea()
                    
                    
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                        
                        VStack {
                            
                            RoundedRectangle(cornerRadius: 16)
                                .blendMode(.destinationOut)
                                .frame(width: 300, height: 200)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.accentColor, lineWidth: 1.0)
                                }
                            
                            Spacer()
                                .frame(height: 16)
                            
                            Text(AppTexts.alignThebarcodeText)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.white)
                            
                            Spacer()
                                .frame(height: 100)
                            
                            FNButton(
                                buttonTitle: AppTexts.enterBarcodeManuallyText,
                                backgroundEnable: false,
                                buttonIconName: "keyboard"
                            ) {
                                barcodeViewModel.isManualEntryOpen = true
                            }
                            .padding(.horizontal, 32)
                        }
                    }
                    .compositingGroup()
                    .frame(height: UIScreen.main.bounds.height)
                    
                    
                }
            }
            .scrollDisabled(true)
            .ignoresSafeArea()
            .withCustomBackButton(withTitle: AppTexts.scanABarCodeText, backButtonTint: .white, backButtonType: .close)
            .navigationDestination(isPresented: $barcodeViewModel.isBarcodeDetected, destination: {
                ReviewItemView(barcode: self.barcodeViewModel.barcodeValue, isPresented: $isPresented, mealType: self.barcodeViewModel.mealType)
                    .onDisappear {
                        barcodeViewModel.isSessionRunning = true
                        self.barcodeViewModel.barcodeValue = ""
                    }
            })
            .sheet(isPresented: $barcodeViewModel.isManualEntryOpen) {
                BarcodeManualEntryView(code: $barcodeViewModel.barcodeValue){
                    barcodeViewModel.isBarcodeDetected = true
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .onFirstAppear {
                barcodeViewModel.loadAllFoodCatalogData(foodCatalogManager: self.appRootManager.foodCatalogManager)
            }
        }
        
    }
    
}

#Preview {
    BarcodeView(mealType: .breakfast, isPresented: .constant(false))
}
