//
//  Location.swift
//  
//
//  Created by michael moldawski on 4/10/17.
//

import Foundation
struct Location
{
    var latitude: Double = 0
    var longitude: Double = 0
    init()
    {}
    init (latitude: Double, longitude: Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
}

