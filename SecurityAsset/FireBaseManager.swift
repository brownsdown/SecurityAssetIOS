//
//  FireBaseManager.swift
//  SecurityAsset
//
//  Created by michael moldawski on 3/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth


class FireBaseManager: NSObject
{
    static let databaseRef = Database.database().reference()
//    static var currentUserID: String = ""
    var currentUser: User? = nil
    
    //MARK:- "Signleton"
    static let shared = FireBaseManager()
    
   func login(email: String, password: String, completion: @escaping((_ succes: Bool) -> Void))
    {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
            
            else
            {
                self.currentUser = user
//                currentUserID = (user?.uid)!
                completion(true)
            }
        }
    }
    
   func createUser(email: String, password: String, completion: @escaping((_ succes: Bool) -> Void))
    {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error
            {
                print(error.localizedDescription)
                LogInViewController.fireBaseAuthError = error
                completion(false)
                
            }
            else
            {
                self.currentUser = user
                self.currentUser?.sendEmailVerification(completion: nil)
//                currentUserID = (user?.uid)!
                completion(true)
            }
        }
       
    }
}


