//
//  BaseManagerDelegate.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI
import Combine
import CoreData

protocol BaseManagerDelegate {
    associatedtype T: Codable
    
    var managerPublisher: AnyPublisher<T, Never> {get}
    var container: NSPersistentContainer {get set}
    var viewContext: NSManagedObjectContext {get set}
    var bgContext: NSManagedObjectContext {get set}
    
    func addNewOrUpdateData(_ newData: T) async -> Bool
    func deleteData(_ deleteData: T) async -> Bool
    func loadData() async
}
