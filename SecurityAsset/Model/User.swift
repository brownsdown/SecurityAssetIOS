//
//  User.swift
//  SecurityAsset
//
//  Created by michael moldawski on 4/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import FirebaseAuth

class ClientUser
{
    var userState: StateUser
    var firstName: String
    var lastName: String
    var adress: Adress
    let bithDate: String
    var location: Location
    var phonePosition: PhonePosition
    
    init(fireBaseUser: User)
    {
        self.userState = fireBaseUser.
        self.firstName = firstName
        self.lastName = lastName
        self.adress = adress
        self.bithDate = birthDate
        self.location = location
        self.phonePosition = phonePosition
    }
    
}

