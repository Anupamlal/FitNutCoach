//
//  FoodDetectorFBManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import SwiftUI
import FirebaseAI

final class FoodDetectorFBManager {

    //MARK: - Constants
    private let modelName = "gemini-2.5-flash"

    //MARK: - Private Methods
    private func runAIModel(image: UIImage, prompt: String) async -> String? {
        
        let ai = FirebaseAI.firebaseAI(backend: .googleAI())

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
    
    private func detectFood(image: UIImage) async -> String? {
        guard let resized = image.resized(maxDimension: 1024) else {
            return nil
        }
        
        let prompt = "Identify up to 6 food items in the image. Return ONLY a JSON array: [{ \"name\": \"<dish or ingredient>\", \"crb\": 0.0, \"ptn\": 0.0, \"fat\": 0.0, \"clry\": 0.0,\"quantity\":0.0(in grams), \"mUnit\": \"<piece or cup or large or slice or bowl or tsp or glass or plate>\", \"cnfdnc\": 0.0 }]. Omit items with confidence < 0.3. Do not include any extra text."
        
        let response = await self.runAIModel(
            image: resized,
            prompt: prompt
        )
        
        return response
        
    }
    
    func getFoodItems(image: UIImage) async -> [FoodCatalogItemModel] {
        
        guard let jsonResponse = await detectFood(image: image) else {
            return []
        }
        
        let finalJsonResponse = jsonResponse.replacingOccurrences(of: "```json", with: "").replacingOccurrences(of: "```", with: "")
        
        if let data = finalJsonResponse.data(using: .utf8) {
            
            do {
                let aiFoodItems = try JSONDecoder().decode([AIFoodItemModel].self, from: data)
                print(aiFoodItems)
                
                return aiFoodItems.map{FoodCatalogItemModel(aiFoodItemModel: $0)}
                
            }catch {
                print(error)
            }
            
        }
        
        return []
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
