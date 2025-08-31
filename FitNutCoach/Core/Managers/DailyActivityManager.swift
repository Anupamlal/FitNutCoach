//
//  DailyActivityManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI
import Combine
import CoreData

class DailyActivityManager: ObservableObject {
        
    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    private let dailyActivitySubject = CurrentValueSubject<DailyActivityModel, Never>(DailyActivityModel())
    
    var managerPublisher: AnyPublisher<DailyActivityModel, Never> {
        dailyActivitySubject.eraseToAnyPublisher()
    }
    
    init(container: NSPersistentContainer) {
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func addNewOrUpdateData(_ newData: DailyActivityModel) async -> Bool {
        let dailyActivity = DailyActivity(context: self.bgContext)
        newData.fillDailyActivity(dailyActivity: dailyActivity, context: self.bgContext)
        
        await bgContext.perform {
            
            do {
                try self.bgContext.save()
            }
            catch {
                print("Error caused during saving DailyActivity", error.localizedDescription)
            }
        }
        
        self.publishDailyActivity(newData)
        return true
    }
    
    func deleteData(_ deleteData: DailyActivityModel) async -> Bool {
        return true
    }
    
    func loadData(date: Date) async -> DailyActivity? {
        let fetchRequest = DailyActivity.fetchRequest()
        let start = Calendar.current.startOfDay(for: date)
        
        fetchRequest.predicate = NSPredicate(format: "date == %@", start as NSDate)
        fetchRequest.fetchLimit = 1
        
        if let dailyActivity = try? viewContext.fetch(fetchRequest).first {
            return dailyActivity
        }
        
        return nil
    }
    
    func loadTodayData() async {
        let date = Date()
        if let dailyActivity = await self.loadData(date: date) {
            let dailyActivityModel = DailyActivityModel(dailyActivity: dailyActivity)
            self.publishDailyActivity(dailyActivityModel)
        }
    }
    
    func addWatersIntake(_ amount: Double) async {
        guard let dailyActivity = await self.loadData(date: Date()) else {
            return
        }
        
        dailyActivity.waterLiters += amount
        _ = await self.addNewOrUpdateData(DailyActivityModel(dailyActivity: dailyActivity))
    }
    
    func addSteps(_ amount: Int) async {
        guard let dailyActivity = await self.loadData(date: Date()) else {
            return
        }
        
        dailyActivity.steps += Int32(amount)
        _ = await self.addNewOrUpdateData(DailyActivityModel(dailyActivity: dailyActivity))
    }
    
    func publishDailyActivity(_ dailyActivityModel: DailyActivityModel) {
        self.dailyActivitySubject.send(dailyActivityModel)
    }

}
