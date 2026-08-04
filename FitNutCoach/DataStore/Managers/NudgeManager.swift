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
    
    private let nudgeSubject = CurrentValueSubject<[NudgeModel], Never>([])
    private let ruleEngine = NudgeRuleEngine()
    
    var managerPublisher: AnyPublisher<[NudgeModel], Never> {
        nudgeSubject.eraseToAnyPublisher()
    }
    
    init(container: NSPersistentContainer) {
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func loadData(date: Date = Date(), viewContextObj: NSManagedObjectContext? = nil) async -> [NudgeModel] {
        let fetchRequest = Nudge.fetchRequest()
        let start = date.getStartOfDate()
        fetchRequest.predicate = NSPredicate(format: "date == %@", start as NSDate)
        
        let context = viewContextObj ?? viewContext
        
        if let nudges = try? context.fetch(fetchRequest).map({ NudgeModel(with: $0) }) {
            return nudges
        }
        return []
    }
    
    func loadData() async -> Bool {
        let nudges = await loadData(date: Date())
        nudgeSubject.send(nudges)
        return true
    }
    
    func syncNudges(
        profile: ProfileModel,
        dailyActivity: DailyActivityModel,
        weather: WeatherModel?
    ) async {
        let today = Date().getStartOfDate()
        let generated = ruleEngine.generateNudges(
            context: NudgeRuleContext(
                profile: profile,
                dailyActivity: dailyActivity,
                weather: weather
            )
        )
        
        let existing = await loadData(date: today, viewContextObj: bgContext)
        var merged: [NudgeModel] = []
        
        for generatedNudge in generated {
            if let existingNudge = existing.first(where: { $0.ruleId == generatedNudge.ruleId }) {
                var updated = generatedNudge
                updated = NudgeModel(
                    id: existingNudge.id,
                    ruleId: generatedNudge.ruleId,
                    title: generatedNudge.title,
                    message: generatedNudge.message,
                    category: generatedNudge.category,
                    priority: generatedNudge.priority,
                    status: existingNudge.status,
                    createdAt: existingNudge.createdAt,
                    date: today,
                    expiresAt: generatedNudge.expiresAt,
                    actionType: generatedNudge.actionType,
                    actionValue: generatedNudge.actionValue,
                    completedAt: existingNudge.completedAt,
                    snoozedUntil: existingNudge.snoozedUntil
                )
                
                if updated.expiresAt != nil && (updated.expiresAt ?? Date()) < Date() && updated.status == .active {
                    updated.markExpired()
                }
                
                if updated.status == .active || updated.status == .completed {
                    merged.append(updated)
                    await upsertNudge(updated)
                }
            } else {
                merged.append(generatedNudge)
                await upsertNudge(generatedNudge)
            }
        }
        
        for existingNudge in existing where existingNudge.status == .completed {
            if !merged.contains(where: { $0.ruleId == existingNudge.ruleId }) {
                merged.append(existingNudge)
            }
        }
        
        let sorted = merged.sorted { lhs, rhs in
            if lhs.priority != rhs.priority { return lhs.priority > rhs.priority }
            return lhs.createdAt > rhs.createdAt
        }
        
        await MainActor.run {
            nudgeSubject.send(sorted)
        }
        
        NudgeNotificationService.shared.scheduleNotifications(for: sorted.filter(\.isVisible))
    }
    
    private func upsertNudge(_ model: NudgeModel) async {
        await bgContext.perform {
            let fetchRequest = Nudge.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "ruleId == %@ AND date == %@", model.ruleId, model.date as NSDate)
            fetchRequest.fetchLimit = 1
            
            let nudge: Nudge
            if let existing = try? self.bgContext.fetch(fetchRequest).first {
                nudge = existing
            } else {
                nudge = Nudge(context: self.bgContext)
            }
            
            model.fill(into: nudge)
            
            do {
                try self.bgContext.save()
            } catch {
                print("Error saving nudge:", error.localizedDescription)
            }
        }
    }
    
    func activeNudges() -> [NudgeModel] {
        nudgeSubject.value.filter(\.isVisible)
    }
    
    func priorityNudges() -> [NudgeModel] {
        activeNudges().filter { $0.priority == .high }
    }
    
    func nudgesByCategory() -> [NudgeCategory: [NudgeModel]] {
        Dictionary(grouping: activeNudges(), by: \.category)
    }
    
    func completedNudges() -> [NudgeModel] {
        nudgeSubject.value
            .filter { $0.status == .completed }
            .sorted { ($0.completedAt ?? $0.createdAt) > ($1.completedAt ?? $1.createdAt) }
    }
    
    func markCompleted(nudge: NudgeModel) async {
        var updated = nudge
        updated.markCompleted()
        await updateNudge(updated)
    }
    
    func markDismissed(nudge: NudgeModel) async {
        var updated = nudge
        updated.markDismissed()
        await updateNudge(updated)
    }
    
    private func updateNudge(_ model: NudgeModel) async {
        await upsertNudge(model)
        
        var allNudges = nudgeSubject.value
        if let index = allNudges.firstIndex(where: { $0.id == model.id }) {
            allNudges[index] = model
        } else {
            allNudges.append(model)
        }
        
        let sorted = allNudges.sorted { lhs, rhs in
            if lhs.priority != rhs.priority { return lhs.priority > rhs.priority }
            return lhs.createdAt > rhs.createdAt
        }
        
        await MainActor.run {
            nudgeSubject.send(sorted)
        }
        
        NudgeNotificationService.shared.scheduleNotifications(for: sorted.filter(\.isVisible))
    }
}
