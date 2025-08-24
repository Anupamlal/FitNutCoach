//
//  PersistenceController.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 23/08/25.
//

import CoreData

final class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "FitNutCoach")

        if inMemory {
            let storeDesc = NSPersistentStoreDescription()
            storeDesc.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [storeDesc]
        }

        // Merge changes from background contexts
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved Core Data error: \(error.localizedDescription)")
            }
        }
    }
}
