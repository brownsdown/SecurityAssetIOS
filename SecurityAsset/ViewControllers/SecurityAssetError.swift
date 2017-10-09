//
//  SecurityAssetError.swift
//  SecurityAsset
//
//  Created by michael moldawski on 9/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation

enum SecurityAssetError: Error{
    case missingRequiredField(fieldName: String)
}
