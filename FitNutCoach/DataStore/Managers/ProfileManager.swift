//
//  ProfileManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 30/08/25.
//

import SwiftUI
import Combine
import CoreData

final class ProfileManager: ObservableObject, BaseManagerDelegate, @unchecked Sendable {
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
        await bgContext.perform {
            let fetchRequest = UserProfile.fetchRequest()
            fetchRequest.fetchLimit = 1
            
            let userProfile: UserProfile
            if let existing = try? self.bgContext.fetch(fetchRequest).first {
                userProfile = existing
            } else {
                userProfile = UserProfile(context: self.bgContext)
            }
            
            newData.fillUserProfile(userProfile: userProfile)
            
            do {
                try self.bgContext.save()
            } catch {
                print("Error caused during saving Userprofile", error.localizedDescription)
            }
        }
        
        await MainActor.run {
            self.profileSubject.send(newData)
        }
        return true
    }
    
    func deleteData(_ deleteData: ProfileModel) async -> Bool {
        return false
    }

    func loadData() async -> Bool {
        let fetchRequest = UserProfile.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        if let userProfile = try? viewContext.fetch(fetchRequest).first {
            let profileModel = ProfileModel(userProfile: userProfile)
            await MainActor.run {
                profileSubject.send(profileModel)
            }
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
    
    /// Saves profile to Core Data and Firebase.
    func saveProfile(_ profileModel: ProfileModel) async -> Bool {
        var profile = profileModel
        if profile.id == nil || profile.id?.isEmpty == true {
            profile.id = UUID().uuidString
        }
        
        let coreDataSaved = await addNewOrUpdateData(profile)
        guard coreDataSaved else { return false }
        
        return await ProfileFBHelper.saveUserProfile(profileModel: profile)
    }
}
