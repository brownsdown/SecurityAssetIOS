//
//  User.swift
//  SecurityAsset
//
//  Created by michael moldawski on 4/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON

class AppUser
{
   
    
    var userState = StateUser.safe
    var group: Group = Group(group: [String]())
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var adress: Adress = Adress()
    var bithDate: String = ""
    var location: Location = Location()
    var phonePosition: PhonePosition = PhonePosition()
    var userFireBase: User? = nil
    
    init()
    {}
    
    // l'init ci dessous doit être complété avec la méthode updateUserFromFirebase  afin de récupérer toute les données du user depuis la DB
    init?(fireBaseUser: User?)
    {
        if let fireBaseUserTest = fireBaseUser
        {
            self.userFireBase = fireBaseUserTest
            self.email = (userFireBase?.email)!
        }
        else{
            return nil
        }
    }
    
    init(userState: StateUser, group: Group,firstName: String, lastName: String, email: String, adress: Adress, birthDate: String, location: Location, phonePosition: PhonePosition)
    {
        self.userState = userState
        self.group = group
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.adress = adress
        self.bithDate = birthDate
        self.location = location
        self.phonePosition = phonePosition
    }
    
    init(group: Group,firstName: String, lastName: String, email: String,adress: Adress, birthDate: String, location: Location, phonePosition: PhonePosition, fireBaseUser: User?)
    {
        self.userState = StateUser.safe
        self.group = group
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.adress = adress
        self.bithDate = birthDate
        self.location = location
        self.phonePosition = phonePosition
        self.userFireBase = fireBaseUser
    }
    
//    func groupFromFireBase(userRef: DatabaseReference)
//    {
//        var j: Int = 0
//        let userGroupRef = userRef.child("Group")
//        userGroupRef.observeSingleEvent(of:.value, with: { (snapshot) in
//
//            for _ in 0 ..< snapshot.childrenCount
//            {
//                j += 1
//                self.group.group.append((snapshot.childSnapshot(forPath: String(j)).value as? String ?? "")!)
//            }
//
//        })
//    }
    
    
    func updateUserFromFirebase(fireBaseUser: User?, handler: @escaping (Bool) -> Void)
    {
        let usersRefTable = Database.database().reference().child("Users")
        let userRefTable = usersRefTable.child((fireBaseUser?.uid)!)
        userRefTable.observeSingleEvent(of:.value, with: { (snapshot) in
            if let value = snapshot.value
            {
                let response = true
                let json = JSON(value)
                print(json)
                guard let userFistName = json["Firstname"].string, let userLastName = json["Lastname"].string, let userBirthdate = json["Birthdate"].string else {return}
                self.firstName = userFistName
                self.lastName = userLastName
                self.bithDate = userBirthdate
                let userLocation = json["Location"]
                self.location = FireBaseManager.getLocationFromJson(userLocation: userLocation)
                let userGroup = json["Group"]
                self.group = FireBaseManager.getGroupFromJson(userGroup: userGroup)
                let userAdress = json["Adress"]
                self.adress = FireBaseManager.getAdressFromJson(userAdress: userAdress)
                DispatchQueue.main.async {
                    handler(response)
                }
            }
        })
    }
    
   
    
}

