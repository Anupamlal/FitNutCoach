//
//  LoginViewModel.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 10/09/25.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth

class LoginViewModel: ObservableObject {

    func signInWithGoogle(currentVC: UIViewController, completion:@escaping ((Bool)->Void)) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false)
            return
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //google sign in authentication response
        GIDSignIn.sharedInstance.signIn(withPresenting: currentVC) { result, error in
            
            guard let result = result else {
                completion(false)
                return
            }
            
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else {
                completion(false)
                return
            }
            
            //Firebase auth
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken, accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { result, error in
                
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
            }
            
        }
        
        completion(false)
    }
    
    func getCurrentController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = scene?.windows.first?.rootViewController
        else {
            return nil
        }
        
        return rootViewController
    }
    
    func getNextAppRoot() async -> AppRootType {
        
        let profileModel = await ProfileFBHelper.getUserProfile()
        
        if profileModel == nil {
            return .profile
        }
        
        return .tabview
    }
}
