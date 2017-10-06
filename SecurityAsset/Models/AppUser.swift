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
    var userState: StateUser = StateUser.safe
    var group: Group = Group(group: [String]())
    var firstName: String = ""
    var lastName: String = ""
    var adress: Adress = Adress()
    var bithDate: String = ""
    var location: Location = Location()
    var phonePosition: PhonePosition = PhonePosition()
    var userFireBase: User? = nil
    
    init()
    {}
    
    init(fireBaseUser: User)
    {
        self.userFireBase = fireBaseUser
    }
    
    init(userState: StateUser, group: Group,firstName: String, lastName: String, adress: Adress, birthDate: String, location: Location, phonePosition: PhonePosition)
    {
        self.userState = userState
        self.group = group
        self.firstName = firstName
        self.lastName = lastName
        self.adress = adress
        self.bithDate = birthDate
        self.location = location
        self.phonePosition = phonePosition
    }
    
}

