//
//  BarcodeModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import SwiftUI

// MARK: - BarCodeModel
struct BarcodeModel: Codable {
    let code: String
    let product: Product
    let status: Int
    let statusVerbose: String
    
    enum CodingKeys: String, CodingKey {
        case code, product, status
        case statusVerbose = "status_verbose"
    }
}

// MARK: - Product
struct Product: Codable {
    let id: String
    let brands, categories, countries: String?
    let expirationDate: String?
    let imageIngredientsURL, imageNutritionURL, imageURL: String?
    let ingredientsText: String?
    let nutriments: Nutriments?
    let origin, productName, productQuantity, productQuantityUnit: String?
    let productType, servingQuantity, servingQuantityUnit: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brands, categories, countries
        case expirationDate = "expiration_date"
        case imageIngredientsURL = "image_ingredients_url"
        case imageNutritionURL = "image_nutrition_url"
        case imageURL = "image_url"
        case ingredientsText = "ingredients_text"
        case nutriments, origin
        case productName = "product_name"
        case productQuantity = "product_quantity"
        case productQuantityUnit = "product_quantity_unit"
        case productType = "product_type"
        case servingQuantity = "serving_quantity"
        case servingQuantityUnit = "serving_quantity_unit"
    }
}

struct Nutriments : Codable {
    let calcium_100g : Double?
    let carbohydrates_100g : Double?
    let energyKcal_100g : Double?
    let fat_100g : Double?
    let fiber_100g : Double?
    let fruitsVegetablesLegumesEstimateFromIngredients_100g : Double?
    let fruitsVegetablesNutsEstimateFromIngredients_100g : Double?
    let novaGroup_100g : Double?
    let nutritionScoreFr_100g : Double?
    let proteins_100g : Double?
    let salt_100g : Double?
    let saturatedFat_100g : Double?
    let sodium_100g : Double?
    let sugars_100g : Double?

    enum CodingKeys: String, CodingKey {

        case calcium_100g = "calcium_100g"
        case carbohydrates_100g = "carbohydrates_100g"
        case energyKcal_100g = "energy-kcal_100g"
        case fat_100g = "fat_100g"
        case fiber_100g = "fiber_100g"
        case fruitsVegetablesLegumesEstimateFromIngredients_100g = "fruits-vegetables-legumes-estimate-from-ingredients_100g"
        case fruitsVegetablesNutsEstimateFromIngredients_100g = "fruits-vegetables-nuts-estimate-from-ingredients_100g"
        case novaGroup_100g = "nova-group_100g"
        case nutritionScoreFr_100g = "nutrition-score-fr_100g"
        case proteins_100g = "proteins_100g"
        case salt_100g = "salt_100g"
        case saturatedFat_100g = "saturated-fat_100g"
        case sodium_100g = "sodium_100g"
        case sugars_100g = "sugars_100g"
    }
}
