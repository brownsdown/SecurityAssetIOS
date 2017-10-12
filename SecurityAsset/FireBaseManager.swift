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
    
    static func storeUserInDB(appUser: AppUser)
    {
        let usersRefTable = databaseRef.child("Users")
        let groupRefTable = databaseRef.child("Group")
        
        storeGroupInDB(groupRefTable: groupRefTable, appUser: appUser)
        storeGeneralInformationUser(usersRefTable: usersRefTable, appUser: appUser)
        storeLocationInDB(usersRefTable: usersRefTable, appUser: appUser )
        storePhonePositionInDB(usersRefTable: usersRefTable, appUser: appUser)
        
        storeAdressInDB(usersRefTable: usersRefTable, appUser: appUser)
        var j = 0
        for group in appUser.group.group
        {
            j += 1
            
            usersRefTable.child((appUser.userFireBase?.uid)!).child("group").child(String(j)).setValue(group)
        }
        
    }
    static func storeGeneralInformationUser(usersRefTable: DatabaseReference, appUser: AppUser)
    {
        usersRefTable.child((appUser.userFireBase?.uid)!).child("User State").setValue(appUser.userState.rawValue)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Email").setValue(appUser.email)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Firstname").setValue(appUser.firstName)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Lastname").setValue(appUser.lastName)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Birthdate").setValue(appUser.bithDate)
    }
    static func storeAdressInDB(usersRefTable: DatabaseReference, appUser: AppUser )
    {
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("Street").setValue(appUser.adress.street)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("number").setValue(appUser.adress.number)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("mailbox").setValue(appUser.adress.mailBox)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("state zip").setValue(appUser.adress.stateZip)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("city").setValue(appUser.adress.city)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("country").setValue(appUser.adress.country)
    }
    
    static func storeLocationInDB(usersRefTable: DatabaseReference, appUser: AppUser )
    {
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Location").child("Latitude").setValue(appUser.location.latitude)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Location").child("Longitude").setValue(appUser.location.longitude)
    }
    static func storePhonePositionInDB(usersRefTable: DatabaseReference, appUser: AppUser )
    {
        usersRefTable.child((appUser.userFireBase?.uid)!).child("PhonePosition").child("PhonePositionX").setValue(appUser.phonePosition.xPosition)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("PhonePosition").child("PhonePositionY").setValue(appUser.phonePosition.yPosition)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("PhonePosition").child("PhonePositionZ").setValue(appUser.phonePosition.zPosition)
    }
    
    static func storeGroupInDB(groupRefTable: DatabaseReference, appUser: AppUser )
    {
        var i = 0
        for group in appUser.group.group
        {
            i += 1
            groupRefTable.child(group).child((appUser.userFireBase?.uid)!).setValue(appUser.email)
        }
    }
    
}




