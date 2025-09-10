//
//  FoodCatalogFBHelper.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FoodCatalogFBHelper {

    class func saveFoodCatalogeItem(foodCataloge: FoodCatalogItemModel) async -> Bool{
        guard let documentID = foodCataloge.id else {
            return false
        }
        
        let db = Firestore.firestore()
        
        do {
            try await db.collection(FirebaseKey.foodCatalog).document(documentID).setData(foodCataloge.asDictionary() ?? [:])
            
            return true
        }catch {
            return false
        }
    }
    
    class func searchFoodCatalogeItem(foodName: String) async -> [FoodCatalogItemModel]? {
        var foodCatalogeItems: [FoodCatalogItemModel] = []
        
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection(FirebaseKey.foodCatalog).whereField("name", isEqualTo: foodName).getDocuments()
            
            print(snapshot)
            
        }
        catch {
            return nil
        }
        
        return nil
    }
    
    class func getAllFoodCatalogeItem() async -> [FoodCatalogItemModel]? {
        var foodCatalogItems: [FoodCatalogItemModel] = []
        
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection(FirebaseKey.foodCatalog).getDocuments()
            
            print(snapshot)
            
            snapshot.documents.forEach { document in
                if let foodCatalogItemModel = try? document.data(as: FoodCatalogItemModel.self) {
                    foodCatalogItems.append(foodCatalogItemModel)
                }
            }
            
            return foodCatalogItems
        }
        catch {
            return nil
        }
        
    }
    
    class func searchFoodCatalogeByBarCode(barCode: String) async -> FoodCatalogItemModel? {
        var foodCatalogeItem: FoodCatalogItemModel?
        
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection(FirebaseKey.foodCatalog).whereField("barcode", isEqualTo: barCode).getDocuments()
            
            print(snapshot)
        }
        
        catch {
            return nil
        }
        
        return nil
    }
}
