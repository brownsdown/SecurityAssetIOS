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
    
    init?(fireBaseUser: User?)
    {
        if let fireBaseUserTest = fireBaseUser
        {   let usersRefTable = Database.database().reference().child("Users")
            let userRefTable = usersRefTable.child((fireBaseUser?.uid)!)
        userRefTable.child("Firstname").observeSingleEvent(of:.value, with: { (snapshot) in
            
                self.firstName = (snapshot.value as? String ?? "")!
            })
            userRefTable.child("Lastname").observeSingleEvent(of:.value, with: { (snapshot) in
                self.lastName = (snapshot.value as? String)!
            })
            userRefTable.child("Birthdate").observeSingleEvent(of:.value, with: { (snapshot) in
                self.bithDate = (snapshot.value as? String)!
            })
            self.adressFromFireBase(userRef: userRefTable)
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
    
    func adressFromFireBase(userRef: DatabaseReference)
    {
        
        let userAdressRef = userRef.child("Adress")
        userAdressRef.child("Number").observeSingleEvent(of:.value, with: { (snapshot) in
            
           self.adress.number = (snapshot.value as? Int ?? 0)!
        })
        userAdressRef.child("Street").observeSingleEvent(of:.value, with: { (snapshot) in
            
            self.adress.street = (snapshot.value as? String ?? "")!
        })
        userAdressRef.child("City").observeSingleEvent(of:.value, with: { (snapshot) in
            
            self.adress.city = (snapshot.value as? String)!
        })
        userAdressRef.child("Statezip").observeSingleEvent(of:.value, with: { (snapshot) in
            
            self.adress.stateZip = (snapshot.value as? Int ?? 0)!
        })
        userAdressRef.child("MailBox").observeSingleEvent(of:.value, with: { (snapshot) in
            
            self.adress.mailBox = (snapshot.value as? Int ?? 0)!
        })
        userAdressRef.child("Country").observeSingleEvent(of:.value, with: { (snapshot) in
            
            self.adress.country = (snapshot.value as? String ?? "")!
        })
    
    }
    
}

