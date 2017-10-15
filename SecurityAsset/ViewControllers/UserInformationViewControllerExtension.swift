//
//  UserInformationViewControllerExtension.swift
//  SecurityAsset
//
//  Created by michael moldawski on 15/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import UIKit
extension UserInformationViewController
{
     
    struct Objects
    {
        
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    //MARK:- Cells sizing methods
    func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
        var maxLabelWidth:  CGFloat = CGFloat()
        for label in labels
        {
            let temp = label.bounds.width
            if maxLabelWidth < temp
            {
                maxLabelWidth = temp
            }
        }
        return maxLabelWidth
    }
    
    
    func updateWidthsForLabels(labels: [UILabel]) {
        let maxLabelWidth = calculateMaxLabelWidth(labels: labels)
        for label in labels {
            let constraint = NSLayoutConstraint(item: label,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: maxLabelWidth)
            label.addConstraint(constraint)
        }
    }
    
    func calculateLabelWidth(label: UILabel) -> CGFloat {
        let width = label.frame.width
        
        return width
    }
}
