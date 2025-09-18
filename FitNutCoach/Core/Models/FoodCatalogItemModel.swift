//
//  FoodCatalogItem.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import SwiftUI

struct FoodCatalogItemModel: Codable {
    let id: String?
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
    let measurementUnit: MeasurementUnit?
    let totalSize: Double?
    let servingSize: Double?
    let totalSizeUnit: String?
    let servingSizeUnit: String?
    
    init(id: String?, brand: String?, caloriesPer100G: Double, carbsPer100G: Double, confidence: Double, fatPer100G: Double, name: String?, proteinPer100G: Double, totalSize: Double, servingSize: Double, foodSourceType: MealSourceType, barcode: String?, imageUrl: String?, measurementUnit: String?, totalSizeUnit: String?, servingSizeUnit: String?) {
        self.id = id
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
        self.measurementUnit = MeasurementUnit(rawValue: measurementUnit ?? "")
        self.imageUrl = imageUrl
        self.totalSizeUnit = totalSizeUnit
        self.servingSizeUnit = servingSizeUnit
    }
    
    init() {
        self.init(id: UUID().uuidString, brand: nil, caloriesPer100G: 0, carbsPer100G: 0, confidence: 0, fatPer100G: 0, name: nil, proteinPer100G: 0, totalSize: 0, servingSize: 0, foodSourceType: .manual, barcode: nil, imageUrl: nil, measurementUnit: nil, totalSizeUnit: nil, servingSizeUnit: nil)
    }
    
    init(barcodeModel: BarcodeModel) {
        self.id = UUID().uuidString
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
        self.servingSizeUnit = barcodeModel.product.servingQuantityUnit
        self.measurementUnit = nil
    }
    
    init(foodCatalogItem: FoodCatalogItem) {
        self.id = foodCatalogItem.id
        self.brand = foodCatalogItem.brand
        self.caloriesPer100G = foodCatalogItem.caloriesPer100G
        self.carbsPer100G = foodCatalogItem.carbsPer100G
        self.confidence = foodCatalogItem.confidence
        self.fatPer100G = foodCatalogItem.fatPer100G
        self.name = foodCatalogItem.name
        self.proteinPer100G = foodCatalogItem.proteinPer100G
        self.foodSourceType = MealSourceType(rawValue: foodCatalogItem.foodSourceType ?? MealSourceType.manual.rawValue) ?? .manual
        self.barcode = foodCatalogItem.barcode
        self.measurementUnit = MeasurementUnit(rawValue: foodCatalogItem.measurementUnit ?? "")
        self.imageUrl = foodCatalogItem.imageUrl
        self.servingSize = foodCatalogItem.servingSize
        self.totalSize = foodCatalogItem.totalSize
        self.totalSizeUnit = foodCatalogItem.totalSizeUnit
        self.servingSizeUnit = foodCatalogItem.servingSizeUnit
    }
    
    func fillFoodCatalogItem(foodCatalogItem: FoodCatalogItem) {
        foodCatalogItem.id = self.id
        foodCatalogItem.brand = self.brand
        foodCatalogItem.caloriesPer100G = self.caloriesPer100G ?? 0
        foodCatalogItem.carbsPer100G = self.carbsPer100G ?? 0
        foodCatalogItem.confidence = self.confidence
        foodCatalogItem.fatPer100G = self.fatPer100G ?? 0
        foodCatalogItem.measurementUnit = self.measurementUnit?.rawValue
        foodCatalogItem.name = self.name
        foodCatalogItem.proteinPer100G = self.proteinPer100G ?? 0
        foodCatalogItem.foodSourceType = self.foodSourceType.rawValue
        foodCatalogItem.barcode = self.barcode
        foodCatalogItem.imageUrl = self.imageUrl
        foodCatalogItem.servingSize = self.servingSize ?? 0
        foodCatalogItem.totalSize = self.totalSize ?? 0
        foodCatalogItem.totalSizeUnit = self.totalSizeUnit
        foodCatalogItem.servingSizeUnit = self.servingSizeUnit
    }
    
}
