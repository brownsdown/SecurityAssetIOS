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
    
    func createAppUser(emailTextField: UITextField, firstNameTextField: UITextField, lastNameTextField: UITextField, groupToJoinOrCreateTextField: UITextField, dateLabel: UILabel, streetTextField: UITextField, streetNumberTextField: UITextField, stateZipTextField: UITextField, mailBoxTextField: UITextField, cityTextField: UITextField, countryTextField: UITextField) -> AppUser?
    {
        var userApp: AppUser?
        let currentUser = FireBaseManager.shared.currentUser
        let email = emailTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let groupToJoin = groupToJoinOrCreateTextField.text ?? ""
        let birthDate = dateLabel.text ?? ""
        
        //MARK:- Adress Attribut
        let street = streetTextField.text ?? ""
        let streetNumber = Int( streetNumberTextField.text ?? "0") ?? 0
        
        
        let mailBox = Int(mailBoxTextField.text ?? "0") ?? 0
        let stateZip = Int(stateZipTextField.text ?? "0") ?? 0
        let city = cityTextField.text ?? ""
        let country = countryTextField.text ?? ""
        
        
        let adresse = Adress(number: streetNumber, street: street, city: city, cp: stateZip, mailBox: mailBox, country: country)
        let phonePosition = PhonePosition()
        let location = Location()
        var group = Group()
        group.addGroup(newGroup: groupToJoin)
        
        userApp = AppUser(group: group, firstName: firstName, lastName: lastName, email: email, adress: adresse, birthDate: birthDate, location: location, phonePosition: phonePosition, fireBaseUser: currentUser)
        
        return userApp
    }
}


