//
//  PhonePosition.swift
//  SecurityAsset
//
//  Created by michael moldawski on 4/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
struct PhonePosition
{
    var xPosition: Double = 0
    var yPosition: Double = 0
    var zPosition: Double = 0
    
    init ()
    {}
    
    init (xPosition: Double, yPosition: Double, zPosition: Double)
    {
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.zPosition = zPosition
    }
}
