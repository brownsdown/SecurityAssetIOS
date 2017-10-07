//
//  Adresse.swift
//  SecurityAsset
//
//  Created by michael moldawski on 4/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
struct Adress
{
    var number: Int = 0
    var street: String = ""
    var city: String = ""
    var stateZip: Int = 0
    var mailBox: Int = 0
    var country: String = ""
    
    init()
    {}
    init(number: Int, street: String, city: String, cp: Int, mailBox: Int, country: String)
    {
        self.number = number
        self.street = street
        self.city = city
        self.stateZip = cp
        self.mailBox = mailBox
        self.country = country
    }
}
