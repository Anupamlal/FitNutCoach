//
//  NudgeManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 16/10/25.
//

import SwiftUI
import CoreData
import Combine

class NudgeManager: NSObject, @unchecked Sendable {
    typealias T = NudgeModel
    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    
    private let nudgeSubject = CurrentValueSubject<[NudgeModel], Never>([NudgeModel()])
    var managerPublisher: AnyPublisher<[NudgeModel], Never>{
        nudgeSubject.eraseToAnyPublisher()
    }
    
    init(container: NSPersistentContainer) {
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func addNewOrUpdateData(_ newData: NudgeModel) async -> Bool {
        let nudge = Nudge(context: self.bgContext)
        newData.fill(into: nudge)
                
        await bgContext.perform {
            
            do {
                try self.bgContext.save()
            }
            catch {
                print("Error caused during saving DailyActivity", error.localizedDescription)
            }
        }
        
        return true
    }
    
    func deleteData(_ deleteData: NudgeModel) async -> Bool {
        return true
    }

    func loadData(date: Date, viewContextObj: NSManagedObjectContext? = nil) async -> [NudgeModel]? {
        let fetchRequest = Nudge.fetchRequest()
        let start = date.getStartOfDate()
        
        fetchRequest.predicate = NSPredicate(format: "date == %@", start as NSDate)
        
        var currentViewContext = viewContextObj
        if currentViewContext == nil {
            currentViewContext = self.viewContext
        }
        
        if let dailyActivity = try? currentViewContext?.fetch(fetchRequest).map({ NudgeModel(with: $0) }) {
            return dailyActivity
        }
        
        return nil
    }
    
    func loadData() async -> Bool {
        if let nudgeData = await loadData(date: Date(), viewContextObj: nil) {
            nudgeSubject.send(nudgeData)
            return true
        }
        return false
    }
    
    func loadActiveNudges() -> [NudgeModel] {
        let allNudges = nudgeSubject.value
        
        let activeNudges = allNudges.filter { $0.state == .active }
        
        return activeNudges
    }
    
    func updateState(nudgeModel: NudgeModel) async {
        let fetchRequest = Nudge.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", nudgeModel.id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        if let nudge = try? viewContext.fetch(fetchRequest).first {
            nudgeModel.fill(into: nudge)
            
            do {
                try viewContext.save()
                
                var allNudges = nudgeSubject.value
                if let index = allNudges.firstIndex(where: { $0.id == nudgeModel.id }) {
                    allNudges[index] = nudgeModel
                    nudgeSubject.send(allNudges)
                }
                
            } catch {
                print("Error saving updated nudge:", error.localizedDescription)
            }
        }
    }
    
    func markAsDone(nudgeModel: NudgeModel) async {
        var updatedNudge = nudgeModel
        updatedNudge.updateState(to: .done)
        
        await self.updateState(nudgeModel: nudgeModel)
    }
    
    func markSnoozed(nudgeModel: NudgeModel, duration: TimeInterval) async {
        var updatedNudge = nudgeModel
        updatedNudge.updateState(to: .snoozed)
        updatedNudge.snoozedUntil = Date().addingTimeInterval(duration)
        
        await self.updateState(nudgeModel: nudgeModel)
    }
        
}
