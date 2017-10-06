//
//  ViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 2/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


class LogInViewController: UIViewController {
   
    //MARK:- Attribut
    var user: AppUser?
    
    
    //MARK:- IBOutlet Properties

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 15
        createAccountButton.layer.cornerRadius = 15
        forgotPasswordButton.layer.cornerRadius = 15
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func buttonClick(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else{return}
        switch title {
        case "Login":
            logIn()
        case "Create Account":
            createUser()
        case "Continue":
           moveForward()
        default:
            print("default")
        }
       
    }
  
    @IBAction func createUserButtonClick(_ sender: UIButton) {
        
    }
    
    func logIn()
    {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        FireBaseManager.shared.login(email: email, password: password) { (success: Bool) in
            if (success)
            {
                self.mailTextField.isUserInteractionEnabled = false
                self.mailTextField.backgroundColor = UIColor.darkGray
                
                self.passwordTextField.isUserInteractionEnabled = false
                self.passwordTextField.backgroundColor = UIColor.darkGray
                
                self.logInButton.setTitle("Continue", for: UIControlState.normal)
                self.createAccountButton.setTitle("LogOut", for: UIControlState.normal)
                
                self.forgotPasswordButton.isEnabled = false
                self.forgotPasswordButton.isHidden = true
                print("login successed")
            }
            else
            {
                print("not succes")
            }
        }
        
    }
    
    func createUser()
    {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        FireBaseManager.shared.createUser(email: email, password: password) { (success) in
            if (success)
            {
                print("user created")
            }
            else
            {
                print("user not created")
            }
        }
    }
    
    func moveForward()
    {
         self.performSegue(withIdentifier: "tabBarRootSegue", sender: nil)
    }
    

}

