//
//  FoodCatalogItem.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import SwiftUI

struct FoodCatalogItem: Codable {
    let id: UUID?
    let brand: String?
    let caloriesPer100G: Double?
    let carbsPer100G: Double?
    let confidence: Double
    let fatPer100G: Double?
    let name: String?
    let proteinPer100G: Double?
    let foodSourceType: MealSourceType
    let barcode: String?
    let imageUrl: String?
    let totalSize: Double?
    let servingSize: Double?
    let totalSizeUnit: String?
    let servingSizeUnit: String?
    
    init(brand: String?, caloriesPer100G: Double, carbsPer100G: Double, confidence: Double, fatPer100G: Double, name: String?, proteinPer100G: Double, totalSize: Double, servingSize: Double, foodSourceType: MealSourceType, barcode: String?, imageUrl: String?, totalSizeUnit: String?, servingSizeUnit: String?) {
        self.id = UUID()
        self.brand = brand
        self.caloriesPer100G = caloriesPer100G
        self.carbsPer100G = carbsPer100G
        self.confidence = confidence
        self.fatPer100G = fatPer100G
        self.name = name
        self.proteinPer100G = proteinPer100G
        self.totalSize = totalSize
        self.servingSize = servingSize
        self.foodSourceType = foodSourceType
        self.barcode = barcode
        self.imageUrl = imageUrl
        self.totalSizeUnit = totalSizeUnit
        self.servingSizeUnit = servingSizeUnit
    }
    
    init(barcodeModel: BarcodeModel) {
        self.id = UUID()
        self.brand = barcodeModel.product.brands
        self.caloriesPer100G = barcodeModel.product.nutriments?.energyKcal_100g
        self.carbsPer100G = barcodeModel.product.nutriments?.carbohydrates_100g
        self.confidence = 1
        self.fatPer100G = barcodeModel.product.nutriments?.fat_100g
        self.name = barcodeModel.product.productName
        self.proteinPer100G = barcodeModel.product.nutriments?.proteins_100g
        
        if let productQuantity = barcodeModel.product.productQuantity, let doubleProductQuantity = Double(productQuantity){
            self.totalSize = doubleProductQuantity
            
        }else {
            self.totalSize = 0
        }
        
        if let servingSize = barcodeModel.product.servingQuantity, let doubleServingSize = Double(servingSize){
            self.servingSize = doubleServingSize
            
        }else {
            self.servingSize = 0
        }
        
        self.foodSourceType = .barcode
        self.barcode = barcodeModel.code
        
        if let imageUrl = barcodeModel.product.imageURL{
            self.imageUrl = imageUrl
            
        }else if let imageUrl = barcodeModel.product.imageIngredientsURL{
            self.imageUrl = imageUrl
            
        }else if let imageUrl = barcodeModel.product.imageNutritionURL {
            self.imageUrl = imageUrl
            
        }else {
            self.imageUrl = nil
        }
        
        self.totalSizeUnit = barcodeModel.product.productQuantityUnit
        self.servingSizeUnit =  barcodeModel.product.servingQuantityUnit
    }
}
