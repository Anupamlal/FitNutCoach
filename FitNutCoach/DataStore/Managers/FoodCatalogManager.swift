//
//  FoodCatalogManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import UIKit
import CoreData
import Combine

final class FoodCatalogManager: ObservableObject, BaseManagerDelegate, @unchecked Sendable {
    
    typealias T = FoodCatalogItemModel

    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    var container: NSPersistentContainer
    
    private let foodCatalogeSingleSubject = CurrentValueSubject<FoodCatalogItemModel, Never>(FoodCatalogItemModel())
    private let foodCatalogeSubject = CurrentValueSubject<[FoodCatalogItemModel], Never>([FoodCatalogItemModel()])
    
    private var foodWithBarcode = [String: FoodCatalogItemModel]()
    private var allFoodCatalog: [FoodCatalogItemModel] = []
    
    var managerPublisher: AnyPublisher<FoodCatalogItemModel, Never> {
        foodCatalogeSingleSubject.eraseToAnyPublisher()
    }
    
    var foodCatalogPublisher: AnyPublisher<[FoodCatalogItemModel], Never> {
        foodCatalogeSubject.eraseToAnyPublisher()
    }
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func addNewOrUpdateData(_ newData: FoodCatalogItemModel) async -> Bool {
        
        let foodCatalogItem = FoodCatalogItem(context: self.bgContext)
        newData.fillFoodCatalogItem(foodCatalogItem: foodCatalogItem)
        
        await bgContext.perform {
            
            do {
                try self.bgContext.save()
            }
            catch {
                print("Error caused during saving FoodCatalog", error.localizedDescription)
            }
        }
                
        if self.allFoodCatalog.count > 0 {
            if self.allFoodCatalog.contains(where: {$0.name != newData.name}) {
                self.allFoodCatalog.append(newData)
                
                if let barcode = newData.barcode {
                    self.foodWithBarcode[barcode] = newData
                }
                
            }
            
        }else {
            self.allFoodCatalog = [newData]
            
            if let barcode = newData.barcode {
                self.foodWithBarcode[barcode] = newData
            }
        }
        
        foodCatalogeSubject.send(self.allFoodCatalog)
        
        return true
    }
    
    func deleteData(_ deleteData: FoodCatalogItemModel) async -> Bool {
        return true

    }
    
    func loadData() async -> Bool {
        let fetchRequest = FoodCatalogItem.fetchRequest()
                
        if let foodCatalogs: [FoodCatalogItem] = try? viewContext.fetch(fetchRequest) {
            self.allFoodCatalog = foodCatalogs.map{ FoodCatalogItemModel(foodCatalogItem: $0)}
            
            self.allFoodCatalog.forEach { foodCatalog in
                if let barcode = foodCatalog.barcode {
                    self.foodWithBarcode[barcode] = foodCatalog
                }
            }
        }
        
        foodCatalogeSubject.send(self.allFoodCatalog)
        
        return true
    }
    
    func searchFoodWithBarcode(_ barcode: String) async -> FoodCatalogItemModel? {
        
        if let foodCatalogItemModel = self.foodWithBarcode[barcode] {
            return foodCatalogItemModel
        }
        
        if let foodCatalogItemModel = await FoodCatalogFBHelper.searchFoodCatalogeByBarCode(barCode: barcode) {
            _ = await self.addNewOrUpdateData(foodCatalogItemModel)
            
            return foodCatalogItemModel
        }
        
        return nil
    }
    
    func searchFoodWithName(_ name: String) async -> [FoodCatalogItemModel]? {
        let foodCatalogs: [FoodCatalogItemModel] = self.allFoodCatalog.filter({ $0.name!.lowercased().contains(name.lowercased()) })
        
        if foodCatalogs.count > 0{
            return foodCatalogs
        }
        
        if let foodCatalogsFB = await FoodCatalogFBHelper.searchFoodCatalogeItem(foodName: name) {
            
            await self.batchInsertOfFoodCatalogItem(allFoodCatalog: foodCatalogsFB)
            
            self.allFoodCatalog += foodCatalogsFB
            
            foodCatalogsFB.forEach { foodCatalog in
                if let barcode = foodCatalog.barcode {
                    self.foodWithBarcode[barcode] = foodCatalog
                }
            }
            
            return foodCatalogsFB
        }
        
        return nil
    }
    
    func searchFoodWithSameName(_ name: String) -> FoodCatalogItemModel? {
        
        let foodName = name.replacingOccurrences(of: "_", with: " ").lowercased()
        
        return self.allFoodCatalog.first(where: {$0.name?.lowercased() == foodName})
    }
    
    func loadAllFoodCatalogFromServer() async -> Bool {
                
        if let allFoodCatalog = await FoodCatalogFBHelper.getAllFoodCatalogeItem() {
            await self.batchInsertOfFoodCatalogItem(allFoodCatalog: allFoodCatalog)
            
            return true
        }
        
        return false
        
    }
    
    func saveFoodCatalogItem(_ foodCatalogItemModel: FoodCatalogItemModel) async -> Bool {

        let isSavedOnServer = await FoodCatalogFBHelper.saveFoodCatalogeItem(foodCataloge: foodCatalogItemModel)
        
        if isSavedOnServer{
            _ = await self.addNewOrUpdateData(foodCatalogItemModel)
            
            return true
        }
        
        return false
    }
    
    private func batchInsertOfFoodCatalogItem(allFoodCatalog: [FoodCatalogItemModel]) async {
        var currentIndex = 0
        
        let entityName = String(describing: FoodCatalogItem.self)
        
        let request = NSBatchInsertRequest(entityName: entityName) { (managedObject: NSManagedObject) -> Bool in
            
            guard currentIndex < allFoodCatalog.count else {return true}
            
            if let foodCatalogItem = managedObject as? FoodCatalogItem {
                allFoodCatalog[currentIndex].fillFoodCatalogItem(foodCatalogItem: foodCatalogItem)
            }
            
            currentIndex += 1
            return false
        }
        
        print("Food Catalog Insert Batch Request = \(request)")
    
        await self.batchInsert(request: request)
        
        print("Food Catalog Insertion Done")
    }
    
    private func batchInsert(request: NSBatchInsertRequest) async {
        await container.performBackgroundTask { privateManagedContext in
            
            privateManagedContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            do {
                try privateManagedContext.execute(request)
                try privateManagedContext.save()
            }
            catch {
                print("Could not batch insert = \(error)")
            }
        }
    }

}
