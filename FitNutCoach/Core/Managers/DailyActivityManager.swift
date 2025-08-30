//
//  DailyActivityManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI
import Combine
import CoreData

class DailyActivityManager: ObservableObject, BaseManagerDelegate {
    
    typealias T = DailyActivityModel
    
    var container: NSPersistentContainer
    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    private let dailyActivitySubject = CurrentValueSubject<DailyActivityModel, Never>(DailyActivityModel())
    
    var managerPublisher: AnyPublisher<DailyActivityModel, Never> {
        dailyActivitySubject.eraseToAnyPublisher()
    }
    
    init(container: NSPersistentContainer) {
        self.container = container
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
                print("Error caused during saving Userprofile", error.localizedDescription)
            }
        }
        
        self.dailyActivitySubject.send(newData)
        return true
    }
    
    func deleteData(_ deleteData: DailyActivityModel) async -> Bool {
        return true
    }
    
    func loadData() async {
        let fetchRequest = DailyActivity.fetchRequest()
        
        fetchRequest.fetchLimit = 1
        
        if let dailyActivity = try? viewContext.fetch(fetchRequest).first {
            let dailyActivityModel = DailyActivityModel(dailyActivity: dailyActivity)
            dailyActivitySubject.send(dailyActivityModel)
        }
    }
    

}
