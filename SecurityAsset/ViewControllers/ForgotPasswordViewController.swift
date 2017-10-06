//
//  ForgotPasswordViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 6/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


class ForgotPasswordViewController: UIViewController {
    
    
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func resetPassword(_ sender: UIButton) {
        if let email = emailTextField.text{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let errorToDisplay = error
                {
                    let alertVC = UIAlertController(title: "Error", message: errorToDisplay.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                        (_) in
                        alertVC.dismiss(animated: true, completion: nil)
                    }
                    
                    alertVC.addAction(alertActionOk)
                    self.present(alertVC, animated: true, completion: nil)
                }
                    
                else
                {
                    let alertVC = UIAlertController(title: "Email sent", message: "An email has been sent to you to modify you're password", preferredStyle: UIAlertControllerStyle.alert)
                    let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                        (_) in
                        alertVC.dismiss(animated: true, completion: nil)
                    }
                    
                    alertVC.addAction(alertActionOk)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPasswordButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
