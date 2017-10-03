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
    static var currentUserID: String = ""
    static var currentUser: User? = nil
    
    static func Login(email: String, password: String, completion: @escaping((_ succes: Bool) -> Void))
    {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error
            {
                print(error.localizedDescription)
                
            }
            else
            {
                currentUser = user
                currentUserID = (user?.uid)!
                completion(true)
            }
        }
    }
    
    static func CreateUser(email: String, password: String, completion: @escaping((_ succes: Bool) -> Void))
    {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error
            {
                print(error.localizedDescription)
                
            }
            else
            {
                currentUser = user
                currentUserID = (user?.uid)!
                completion(true)
            }
        }
       
    }
}


