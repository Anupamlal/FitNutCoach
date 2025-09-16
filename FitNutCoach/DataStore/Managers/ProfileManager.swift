//
//  ProfileManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI
import Combine
import CoreData

class ProfileManager: ObservableObject, BaseManagerDelegate {
    typealias T = ProfileModel
    
    var viewContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    private let profileSubject = CurrentValueSubject<ProfileModel, Never>(ProfileModel())
    
    var managerPublisher: AnyPublisher<ProfileModel, Never> {
        profileSubject.eraseToAnyPublisher()
    }
    
    init(container: NSPersistentContainer) {
        self.viewContext = container.viewContext
        self.bgContext = container.newBackgroundContext()
        self.bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func addNewOrUpdateData(_ newData: ProfileModel) async -> Bool {
        let userProfile = UserProfile(context: self.bgContext)
        newData.fillUserProfile(userProfile: userProfile)
        
        await bgContext.perform {
            
            do {
                try self.bgContext.save()
            }
            catch {
                print("Error caused during saving Userprofile", error.localizedDescription)
            }
        }
        
        self.profileSubject.send(newData)
        return true
    }
    
    func deleteData(_ deleteData: ProfileModel) async -> Bool {
        return false
    }

    func loadData() async -> Bool{
        let fetchRequest = UserProfile.fetchRequest()
        
        fetchRequest.fetchLimit = 1
        
        if let userProfile = try? viewContext.fetch(fetchRequest).first {
            let profileModel = ProfileModel(userProfile: userProfile)
            profileSubject.send(profileModel)
            return true
        }
        
        return false
    }
    
    func loadProfileFromServer() async -> ProfileModel? {
        
        if let profileModel = await ProfileFBHelper.getUserProfile() {
            _ = await self.addNewOrUpdateData(profileModel)
            
            return profileModel
        }
        
        return nil
    }

}
