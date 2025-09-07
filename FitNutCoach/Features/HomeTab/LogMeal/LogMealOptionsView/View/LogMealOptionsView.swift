//
//  LogMealOptionsView.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 01/09/25.
//

import SwiftUI
import CoreML
import Vision

struct LogMealOptionsView: View {
    
    @Environment(\.dismiss) var dismiss
    var logMealCallback: ((MealSourceType)->Void)?
    
    var body: some View {
        VStack {
            
            VStack(spacing: 8) {
                Text(AppTexts.logMealText)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                                    
                
                Text(AppTexts.chooseMealOptionText)
                    .foregroundStyle(Color.textSecondary)
                    .font(.system(size: 14))
            }
            
            Spacer()
                .frame(height: 20)
            
            LogMealOptionView(mealSourceType: .photo) { optionType in
                if let logMealCallback = self.logMealCallback {
                    logMealCallback(optionType)
                    dismiss()
                }
            }
            
            LogMealOptionView(mealSourceType: .barcode) { optionType in
                if let logMealCallback = self.logMealCallback {
                    logMealCallback(optionType)
                    dismiss()
                }
            }
            
            LogMealOptionView(mealSourceType: .manual) { optionType in
                if let logMealCallback = self.logMealCallback {
                    logMealCallback(optionType)
                    dismiss()
                }
            }
            
            Spacer()
            
        }
        .padding(.all, 30)

    }
    
//    
//    func detectFood() {
////        guard let model = try? DetectFood(configuration: .init()) else {
////            return
////        }
////        guard let cdimage = UIImage(named: "dinner2")?.cgImage else {
////            return
////        }
////        
////        guard let result = try? model.prediction(input: DetectFoodInput(imageWith: cdimage)) else {
////            print("prediction failed")
////            return
////        }
////        
////        let confidence = result.foodConfidence["\(result.classLabel)"]! * 100.0
////        let converted = String(format: "%.2f", confidence)
////        
////        print("\(result.classLabel) - \(converted) %")
//        
////        guard let model = try? IndianFoodClassifier(configuration: .init()) else {
////            return
////        }
////        
////        guard let cdimage = UIImage(named: "dinner2")?.cgImage else {
////            return
////        }
////        
////        guard let result = try? model.prediction(input: IndianFoodClassifierInput(imageWith: cdimage)) else {
////            print("prediction failed")
////                        return
////        }
////        
////        print(result)
//        
////        let confidence = result.featureNames
////        let converted = String(format: "%.2f", confidence)
////        
////        print("\(result.classLabel) - \(converted) %")
//        
//        guard let cgImage = UIImage(named: "dinner")?.cgImage else { return }
//
//        // 1. Load model
//        guard let model = try? VNCoreMLModel(for: IndianFoodClassifier(configuration: .init()).model) else {
//            print("❌ Failed to load model")
//            return
//        }
//
//        // 2. Create request
//        let request = VNCoreMLRequest(model: model) { request, error in
//            if let results = request.results as? [VNClassificationObservation] {
//                // Take top result
//                if let best = results.first {
//                    print("🍽️ Predicted food: \(best.identifier) (\(best.confidence))")
//                }
//            }
//        }
//
//        // 3. Run request
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        try? handler.perform([request])
//    }
}

#Preview {
    LogMealOptionsView()
}
