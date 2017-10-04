//
//  ViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 2/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit


class LogInViewController: UIViewController {
   
    //MARK:- IBOutlet Properties
    @IBOutlet weak var emailTextField: UITextField!
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
    @IBAction func logInButtonClick(_ sender: UIButton) {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        FireBaseManager.shared.Login(email: email, password: password) { (success: Bool) in
            if (success)
            {
                print("login successed")
            }
            else
            {
                print("not succes")
            }
        }
    }
  
    @IBAction func createUserButtonClick(_ sender: UIButton) {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        FireBaseManager.shared.CreateUser(email: email, password: password) { (success) in
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
    

}

