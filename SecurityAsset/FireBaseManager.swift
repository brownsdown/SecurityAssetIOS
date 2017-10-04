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
    
    //MARK: - "Signleton"
    static let shared = FireBaseManager()
    
   func Login(email: String, password: String, completion: @escaping((_ succes: Bool) -> Void))
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
    
   func CreateUser(email: String, password: String, completion: @escaping((_ succes: Bool) -> Void))
    {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
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
}


