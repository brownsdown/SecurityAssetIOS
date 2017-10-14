//
//  CreateUserFormExtension.swift
//  SecurityAsset
//
//  Created by michael moldawski on 14/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import UIKit
extension CreateUserFormTableViewController
{
    
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
    
    //MARK:- alertActions handling
    func initAlertActions()
    {
        self.alertActionOkSpecial = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (_) in
            
            self.alertVC?.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
        }
        self.alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (_) in
            self.alertVC?.dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlerteVC (title: String, message: String, alertAction1: UIAlertAction, alertAction2: UIAlertAction?)
    {
        self.alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let alertActionTest = alertAction2
        {
            self.alertVC?.addAction(alertAction1)
            self.alertVC?.addAction(alertActionTest)
        }
            
        else
        {
            self.alertVC?.addAction(alertAction1)
        }
        
        self.present(self.alertVC!, animated: true, completion: nil)
    }
}
