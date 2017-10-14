//
//  LogInViewControllerExtension.swift
//  SecurityAsset
//
//  Created by michael moldawski on 14/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import UIKit
extension LogInViewController
{
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
    
    func showAlerteVCMailNotVerified ()
    {
        
        self.showAlerteVC(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \((self.user?.userFireBase?.email)!)?", alertAction1: self.alertActionYes!, alertAction2: self.alertActionNo!)
    }
    
    func initAlertActions()
    {
        self.alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (_) in
            self.alertVC?.dismiss(animated: true, completion: nil)
        }
        self.alertActionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        {
            (_) in
            self.user?.userFireBase?.sendEmailVerification(completion: nil)
            
            self.alertVC?.dismiss(animated: true, completion: nil)
            
            let alertExplanationVC = UIAlertController(title: "To Do", message: "Please sign out and come back after validated your email adress by following instruction sent to you by email.", preferredStyle: UIAlertControllerStyle.alert)
            let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
            { (_) in
                self.alertVC?.dismiss(animated: true, completion: nil)
            }
            
            alertExplanationVC.addAction(alertActionOk)
            self.present(alertExplanationVC, animated: true, completion: nil)
        }
        self.alertActionNo = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            (_) in
            
            self.alertVC?.dismiss(animated: true, completion: nil)
        }
    }
}
