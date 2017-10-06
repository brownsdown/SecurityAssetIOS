//
//  Group.swift
//  SecurityAsset
//
//  Created by michael moldawski on 5/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation

struct Group
{
    var group = [String]()
  
    
    init(group: [String])
    {
        self.group = group
    }
    
    mutating func addGroup(newGroup: String)
    {
        group.append(newGroup)
    }
    
    mutating func deleteGroup(groupToDelete: String) -> Bool
    {
        var idxToDelete: Int?
        innerLoop: for (idx, group) in group.enumerated()
        {
            if group == groupToDelete
            {
                idxToDelete = idx
                break innerLoop
            }
        }
        
        if let index = idxToDelete
        {
            group.remove(at: index)
            return true
        }
        else
        {
            return false
        }
    }
    
}
