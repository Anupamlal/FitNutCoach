//
//  Untitled.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 16/09/25.
//

import SwiftUI
import CoreData
import Combine

class FoodHistoryManager {
    
    private let frcWrapper: GenericFRC<FoodItem>
    private let context: NSManagedObjectContext
    private let cutOffDays = 30
    private let recentLimit = 15
    private let frequentLimit = 15
    
    private var cancellables = Set<AnyCancellable>()
    private let foodHistorySubject = CurrentValueSubject<([FoodItemModel], [FoodItemModel]), Never>(([FoodItemModel()],[FoodItemModel()]))

    var foodHistoryPublisher: AnyPublisher<([FoodItemModel], [FoodItemModel]), Never> {
        foodHistorySubject.eraseToAnyPublisher()
    }
    
    init(context: NSManagedObjectContext) {
        
        let cutoff = Calendar.current.date(byAdding: .day, value: -cutOffDays, to: Date()) ?? Date.distantPast
        let predicate = NSPredicate(format: "createdAt >= %@", cutoff as NSDate)
        
        // Sort by createdAt desc (most recent first)
        let sort = [NSSortDescriptor(key: "createdAt", ascending: false)]
        self.context = context
        
        self.frcWrapper = GenericFRC(
            context: self.context,
            predicate: predicate,
            sortDescriptors: sort,
            sectionNameKeyPath: nil,
            fetchLimit: nil
        )
        
        frcWrapper.$fetchedObjects
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] items in
                guard let self = self else { return }
                self.computeAllAndPublish(items: items)
            }
            .store(in: &cancellables)
        
    }
    
    private func computeAllAndPublish(items: [FoodItem]) {
        Task {
            async let foodHistory = self.computeHistoryFoodItems(from: items)
            async let frequentFoods = self.computeFrequentFoodItems(from: items)
            
            let _ = await [foodHistory, frequentFoods]
                        
            await foodHistorySubject.send((foodHistory, frequentFoods))
        }
    }
    
    private func computeHistoryFoodItems(from items: [FoodItem]) async -> [FoodItemModel] {
        var seen = Set<String>()
        var distinct: [FoodItem] = []
        for item in items {
            guard let cid = item.foodRefId else { continue }
            if !seen.contains(cid) {
                seen.insert(cid)
                distinct.append(item)
            }
            if distinct.count == recentLimit { break }
        }
        
        return distinct.map{FoodItemModel(foodItem: $0, isRequiredNewId: true)}
    }
    
    private func computeFrequentFoodItems(from items: [FoodItem]) async -> [FoodItemModel]{
        var counts: [String: Int] = [:]
        var latestEntry: [String: FoodItem] = [:]
        
        for item in items {
            guard let cid = item.foodRefId else { continue }
            counts[cid, default: 0] += 1
            
            if latestEntry[cid] == nil {
                latestEntry[cid] = item
            }
        }
        
        let sortedCatalogIds = counts.keys.sorted {
            let c0 = counts[$0]!, c1 = counts[$1]!
            if c0 != c1 { return c0 > c1 }
            return (latestEntry[$0]?.createdAt ?? .distantPast) > (latestEntry[$1]?.createdAt ?? .distantPast)
        }
        
        let frequent = sortedCatalogIds.prefix(frequentLimit).compactMap { latestEntry[$0] }
       
        return frequent.map{FoodItemModel(foodItem: $0, isRequiredNewId: true)}
    }
    
}
