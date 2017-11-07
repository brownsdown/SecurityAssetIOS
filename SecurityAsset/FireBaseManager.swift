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
import SwiftyJSON

class FireBaseManager: NSObject
{
    static let databaseRef = Database.database().reference()
    
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
                DispatchQueue.main.async {
                    self.currentUser = user
                    completion(true)
                }
                
            }
        }
    }
    
    // La fonction ci-dessous créé le user Firebase et envoi le mail de vérification pour approuver le compte
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
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    // Cette fonction est le constructeur du AppUser ds le CreationForm
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
    
    // Cette fonction est appellé pour stoquer les informations du user, tant dans la tables group que la table Users.
    static func storeUserInDB(appUser: AppUser)
    {
        let usersRefTable = databaseRef.child("Users")
        let groupRefTable = databaseRef.child("Group")
        let userGroupRefTable = usersRefTable.child((appUser.userFireBase?.uid)!).child("Group")
        
        storeGeneralInformationUser(usersRefTable: usersRefTable, appUser: appUser)
        storeLocationInDB(usersRefTable: usersRefTable, appUser: appUser )
        storePhonePositionInDB(usersRefTable: usersRefTable, appUser: appUser)
        storeAdressInDB(usersRefTable: usersRefTable, appUser: appUser)
        storeUserGroups(userGroupRef: userGroupRefTable, appUser: appUser)
        storeGroupInDB(groupRefTable: groupRefTable, appUser: appUser)
        
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
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("Number").setValue(appUser.adress.number)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("Mailbox").setValue(appUser.adress.mailBox)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("Statezip").setValue(appUser.adress.stateZip)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("City").setValue(appUser.adress.city)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Adress").child("Country").setValue(appUser.adress.country)
    }
    
    static func storeLocationInDB(usersRefTable: DatabaseReference, appUser: AppUser )
    {
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Location").child("Latitude").setValue(appUser.location.latitude)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("Location").child("Longitude").setValue(appUser.location.longitude)
    }
    
    // Pas utilisée
    static func storePhonePositionInDB(usersRefTable: DatabaseReference, appUser: AppUser )
    {
        usersRefTable.child((appUser.userFireBase?.uid)!).child("PhonePosition").child("PhonePositionX").setValue(appUser.phonePosition.xPosition)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("PhonePosition").child("PhonePositionY").setValue(appUser.phonePosition.yPosition)
        usersRefTable.child((appUser.userFireBase?.uid)!).child("PhonePosition").child("PhonePositionZ").setValue(appUser.phonePosition.zPosition)
    }
    
    // La méthode ci-dessous stoque le user dans la table des groupe correspondant
    static func storeGroupInDB(groupRefTable: DatabaseReference, appUser: AppUser )
    {
        var i = 0
        if !(appUser.group.group[0] == "")
        {
            for group in appUser.group.group
            {
                i += 1
                groupRefTable.child(group).child((appUser.userFireBase?.uid)!).child("Location").child("Latitude").setValue(appUser.location.latitude)
                groupRefTable.child(group).child((appUser.userFireBase?.uid)!).child("Location").child("Longitude").setValue(appUser.location.longitude)
                groupRefTable.child(group).child((appUser.userFireBase?.uid)!).child("User State").setValue(appUser.userState.rawValue)
            }
        }
    }
    
    // La méthode ci-dessous stoque les groupes du user dans la table de l'user
    static func storeUserGroups(userGroupRef: DatabaseReference, appUser: AppUser)
    {
        var j = 0
        if !(appUser.group.group[0] == "")
        {
            for group in appUser.group.group
            {
                j += 1
                userGroupRef.child("group"+String(j)).setValue(group)
            }
        }
    }
    
    static func getGroupFromJson(userGroup: JSON) -> Group
    {
        let count = userGroup.count
        var groupToReturn: Group = Group()
        if count != 0
        {
            for i in 1...count
            {
                groupToReturn.group.append(userGroup["group"+String(i)].string!)
                print(userGroup["group"+String(i)].string!)
            }
        }
        return groupToReturn
    }
    
    static func getAdressFromJson(userAdress: JSON) -> Adress
    {
        let count = userAdress.count
        var adressToReturn: Adress = Adress()
        var adressFields = ["City","Country","Mailbox","Number","Statezip","Street"]
        
        for i in 0...(count-1)
        {
            switch i
            {
            case 0:
                adressToReturn.city = userAdress[adressFields[i]].string!
            case 1 :
                adressToReturn.country = userAdress[adressFields[i]].string!
            case 2 :
                adressToReturn.mailBox = userAdress[adressFields[i]].int!
            case 3 :
                adressToReturn.number = userAdress[adressFields[i]].int!
            case 4 :
                adressToReturn.stateZip = userAdress[adressFields[i]].int!
            case 5 :
                adressToReturn.street = userAdress[adressFields[i]].string!
            default:
                print("default")
            }
            
        }
        return adressToReturn
    }
    
    static func getLocationFromJson(userLocation: JSON) -> Location
    {
        let count = userLocation.count
        var locationToReturn: Location = Location()
        for i in 0...(count-1)
        {
            switch i
            {
            case 0:
                locationToReturn.latitude = userLocation["Latitude"].double!
            case 1:
                locationToReturn.longitude = userLocation["Longitude"].double!
            default:
                locationToReturn.latitude = 0.0
                locationToReturn.longitude = 0.0
            }
        }
        return locationToReturn
    }
    
    static func updateUserStatusInDB(usersRefTable: DatabaseReference, appUser: AppUser)
    {
        let ref = usersRefTable
        let post = ["User State": appUser.userState.rawValue]
        ref.updateChildValues(post)
        
        
        // Après avoir mis à jour la table user on met à jour la table Group
        for group in appUser.group.group
        {
            let groupRefTable = databaseRef.child("Group").child(group).child((appUser.userFireBase?.uid)!)
            groupRefTable.updateChildValues(post)
        }
        
    }
    
    // La méthode ci-dessous met à jours la localisation du user dans la DB
    static func updateUserLocationInDB (usersRefTable: DatabaseReference, appUser: AppUser)
    {
        let ref = usersRefTable.child("Location")
        let post = ["Latitude": appUser.location.latitude, "Longitude": appUser.location.longitude]
        ref.updateChildValues(post)
        
        //après avoir mis à jours la localisation du user dans la table Users, on met à jours la table Group
        for group in appUser.group.group
        {
            let groupRefTable = databaseRef.child("Group").child(group).child((appUser.userFireBase?.uid)!).child("Location")
            groupRefTable.updateChildValues(post)
        }
    }
    
}


