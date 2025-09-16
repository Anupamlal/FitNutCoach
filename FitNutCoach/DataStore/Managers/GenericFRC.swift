//
//  GenericFRC.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 17/09/25.
//


import Foundation
import CoreData
import Combine

/// Generic wrapper around NSFetchedResultsController that publishes the fetched objects.
/// T must be an NSManagedObject subclass (your Core Data entity).
final class GenericFRC<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {

    // Published array exposed to ViewModels / Views
    @Published private(set) var fetchedObjects: [T] = []

    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<T>!

    // Current configuration
    private var predicate: NSPredicate?
    private var sortDescriptors: [NSSortDescriptor]
    private var sectionNameKeyPath: String?
    private var fetchLimit: Int?

    /// Init with initial configuration
    init(context: NSManagedObjectContext,
         predicate: NSPredicate? = nil,
         sortDescriptors: [NSSortDescriptor] = [],
         sectionNameKeyPath: String? = nil,
         fetchLimit: Int? = nil) {
        self.context = context
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        self.sectionNameKeyPath = sectionNameKeyPath
        self.fetchLimit = fetchLimit
        super.init()
        buildFRCAndPerformFetch()
    }

    // MARK: - Public helpers

    /// Reconfigure and refetch (call when you want to change predicate / sort)
    func update(predicate: NSPredicate? = nil,
                sortDescriptors: [NSSortDescriptor]? = nil,
                sectionNameKeyPath: String? = nil,
                fetchLimit: Int? = nil) {
        if let p = predicate { self.predicate = p }
        if let s = sortDescriptors { self.sortDescriptors = s }
        if sectionNameKeyPath != nil { self.sectionNameKeyPath = sectionNameKeyPath }
        if fetchLimit != nil { self.fetchLimit = fetchLimit }
        buildFRCAndPerformFetch()
    }

    /// Force refetch (keeps existing config)
    func refetch() {
        performFetch()
    }

    /// Access underlying FRC if advanced usage required
    func underlyingFRC() -> NSFetchedResultsController<T> {
        return frc
    }

    // MARK: - Private

    private func buildFRCAndPerformFetch() {
        let request = T.fetchRequest()
        // cast is safe because T.fetchRequest() returns NSFetchRequest<NSFetchRequestResult>
        guard let typedRequest = request as? NSFetchRequest<T> else {
            fatalError("Unexpected fetchRequest type for \(T.self)")
        }

        typedRequest.predicate = predicate
        typedRequest.sortDescriptors = sortDescriptors
        if let limit = fetchLimit { typedRequest.fetchLimit = limit }

        // create frc
        frc = NSFetchedResultsController(fetchRequest: typedRequest,
                                         managedObjectContext: context,
                                         sectionNameKeyPath: sectionNameKeyPath,
                                         cacheName: nil)
        frc.delegate = self
        performFetch()
    }

    private func performFetch() {
        do {
            try frc.performFetch()
            // If nil, turn into empty array
            fetchedObjects = frc.fetchedObjects ?? []
        } catch {
            print("GenericFRC performFetch error for \(T.self):", error)
            fetchedObjects = []
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Update published values when content changes
        DispatchQueue.main.async { [weak self] in
            self?.fetchedObjects = (self?.frc.fetchedObjects) ?? []
        }
    }
}
