//
//  FoodDetectorManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 21/09/25.
//

import SwiftUI
import Vision
import CoreML

class FoodDetectorManager {
    
    //MARK: - Constants
    private let foodDetectorFBManager: FoodDetectorFBManager
    private var completionHandler: (([String], [Double]) -> Void)?
    
    //MARK: - Init Method
    init() {
        self.foodDetectorFBManager = FoodDetectorFBManager()
    }
    
    lazy var detectionRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: FoodAIClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processDetections(for: request, error: error)
            })
            
            request.imageCropAndScaleOption = .scaleFit
            return request
        }
        catch {
            fatalError("Failed to load Vision ML Model from bundle \(error)")
        }
    }()
    
    //MARK: - Private Methods
    private func getFoodFromMLModel(image: UIImage, completion: @escaping ([String], [Double]) -> Void) {
        self.completionHandler = completion
        self.classifyImage(image)
    }
    
    private func classifyImage(_ uiImage: UIImage) {
        
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(uiImage.imageOrientation.rawValue))
        guard let ciimage = CIImage(image: uiImage) else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciimage, orientation: orientation!)
            do {
                try handler.perform([self.detectionRequest])
            }
            catch {
                print("failed to perform detection with error \(error)")
            }
        }
    }
    
    private func processDetections(for request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            print("No results")
            return
        }
        
        let topFiveOutputs = results.prefix(5)
        let allIdentifers = topFiveOutputs.map{$0.identifier}
        let allConfidenceLogits: [Double] = topFiveOutputs.map{Double($0.confidence)}
        let allConfidence = self.softmax(allConfidenceLogits)
        
        print("allIdentifers: \(allIdentifers)")
        print("allConfidence: \(allConfidence)")
        if let completionHandler = self.completionHandler {
            completionHandler(allIdentifers, allConfidence)
        }
    }
    
    private func softmax(_ logits: [Double]) -> [Double] {
        let maxVal = logits.max() ?? 0
        let exps = logits.map { exp($0 - maxVal) }
        let sum = exps.reduce(0, +)
        return exps.map { $0 / sum }
    }
    
    /// Image Detection using AI
    private func getFoodFromGeminiAI(image: UIImage) async -> [FoodCatalogItemModel] {
        return await foodDetectorFBManager.getFoodItems(image: image)
    }
        
    //MARK: - Internal Methods
    func detectFood(foodCatalogManager: FoodCatalogManager, image: UIImage, completion: @escaping ([FoodItemModel]) -> Void) {
        
        self.getFoodFromMLModel(image: image) { names, confidences in
            
            var allFoodModel: [FoodItemModel] = []
            
            for (index, name) in names.enumerated() {
                
                print("Food detected: \(name)")
                print("Food detected: \(confidences[index])")
                
                if var foodCatalogModel = foodCatalogManager.searchFoodWithSameName(name) {
                    foodCatalogModel.confidence = Double(confidences[index])
                    allFoodModel.append(FoodItemModel(foodCatalogItem: foodCatalogModel))
                }
            }
            
            completion(allFoodModel)
        }
        
    }
    
    func detectFoodDirectlyUsingAI(image: UIImage) async -> [FoodCatalogItemModel] {
        return await getFoodFromGeminiAI(image: image)
    }
    
}
