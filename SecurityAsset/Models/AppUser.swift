//
//  User.swift
//  SecurityAsset
//
//  Created by michael moldawski on 4/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import FirebaseAuth

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
    
}

