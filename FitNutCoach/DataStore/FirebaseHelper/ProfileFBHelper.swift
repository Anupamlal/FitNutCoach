//
//  ProfileFBHelper.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileFBHelper  {

    class func saveUserProfile(profileModel: ProfileModel) async -> Bool {
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return false
        }
        
        do {
            let _ = try await Database.database().reference().child(FirebaseKey.users)
                .child(currentUserEmail.getEmailAsId()).child(FirebaseKey.userInfo).updateChildValues(profileModel.asDictionary() ?? [:])
            
            return true
            
        }catch {
            return false
        }
        
    }
    
    class func getUserProfile() async -> ProfileModel? {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return nil
        }
        
        do {
            let profileModel = try await Database.database().reference().child(FirebaseKey.users)
                .child(currentUserEmail.getEmailAsId()).child(FirebaseKey.userInfo).getData().data(as: ProfileModel.self)
            
            return profileModel
            
        }catch {
            return nil
        }
        
    }
}
