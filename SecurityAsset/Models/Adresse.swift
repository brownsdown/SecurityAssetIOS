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
    var cp: Int = 0
    var mailBox: Int = 0
    
    init()
    {}
    init(number: Int, street: String, city: String, cp: Int, mailBox: Int)
    {
        self.number = number
        self.street = street
        self.city = city
        self.cp = cp
        self.mailBox = mailBox
    }
}
