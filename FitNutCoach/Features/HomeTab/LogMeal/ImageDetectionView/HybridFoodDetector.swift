//
//  HybridFoodDetector.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 19/09/25.
//

import UIKit
import FirebaseCore
import FirebaseMLModelDownloader
import FirebaseAI

final class HybridFoodDetector {

    private let onDeviceConfidenceThreshold: Float = 0.6

    static let shared = HybridFoodDetector()
    private init() {}
    
    func callGeminiFallback(_ uiImage: UIImage) async -> FoodCatalogItemModel? {

        guard let resized = uiImage.resized(maxDimension: 1024) else {
            return nil
        }
        
        let prompt = "Identify up to 6 food items in the image. Return ONLY a JSON array: [{ \"name\": \"<dish or ingredient>\", \"carbs\": 0.0, \"protein\": 0.0, \"fat\": 0.0, \"calories\": 0.0,\"quantity\":0.0, \"quantity_unit\": \"<gm or peice>\", \"confidence\": 0.0 }]. Omit items with confidence < 0.3. Do not include any extra text."
        
        let response = await FirebaseAIClient.shared.runModel(
            image: resized,
            prompt: prompt)
        
        return nil
        
    }

    func analyze(_ uiImage: UIImage) async -> FoodCatalogItemModel? {
        return await self.callGeminiFallback(uiImage)
    }
    
    func detectFoodUsingMLModel(_ uiImage: UIImage, completion: @escaping (()->Void)) {
        
    }
}

// UIImage helper: resize
extension UIImage {
    func resized(maxDimension: CGFloat) -> UIImage? {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else { return self }
        let scale = maxDimension / maxSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

// Placeholder Firebase AI client singleton - replace with actual SDK object from Firebase AI Logic
// This is only here to make the sample compile in concept.
class FirebaseAIClient {
    static let shared = FirebaseAIClient()
    private let modelName = "gemini-2.5-flash"

    func runModel(image: UIImage, prompt: String) async -> String? {
        
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())

        // Create a `GenerativeModel` instance with a model that supports your use case
        let model = ai.generativeModel(modelName: modelName)
        
        do {
            let response = try await model.generateContent(image, prompt)
            print(response.text ?? "No text in response.")
            return response.text
        }
        catch {
            print(error)
            return nil
        }
    }
}
