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
    static var fireBaseAuthError: Error?
    var alertVC: UIAlertController?
    
    
    
    
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
        case "Sign in":
            SignIn()
        case "Create account":
            createUser()
        case "Continue":
            moveForward()
        case "Sign out":
            signOut()
        default:
            print("default")
        }
        
    }
    
    
    
    func SignIn()
    {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        FireBaseManager.shared.login(email: email, password: password) { (success: Bool) in
            if (success)
            {
                self.user = AppUser(fireBaseUser: FireBaseManager.shared.currentUser!)
                self.mailTextField.isUserInteractionEnabled = false
                self.mailTextField.backgroundColor = UIColor.darkGray
                
                self.passwordTextField.isUserInteractionEnabled = false
                self.passwordTextField.backgroundColor = UIColor.darkGray
                
                self.logInButton.setTitle("Continue", for: UIControlState.normal)
                self.createAccountButton.setTitle("Sign out", for: UIControlState.normal)
                
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

                let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    (_) in
                    
                    self.dismiss(animated: true, completion: {

                        self.alertVC?.dismiss(animated: true, completion: nil)
                    })
                }
                self.showAlerteVCOkButton(title: "User creation", message: "A verifying email has been sent to \(email). Please go to your mail to verify it before clicking on \((self.logInButton.titleLabel?.text)!)", alertAction1: alertActionOk, alertAction2: nil)
                print("user created")
                
            }
                
            else
            {
                guard let errorToDisplay = LogInViewController.fireBaseAuthError else{return}
                let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    (_) in
                    
                    self.dismiss(animated: true, completion: {
                        self.alertVC?.dismiss(animated: true, completion: nil)
                    })
                }
                 self.showAlerteVCOkButton(title: "User creation", message: "\(errorToDisplay.localizedDescription)", alertAction1: alertActionOk, alertAction2: nil)
                
                print("user not created")
            }
        }
    }
    
    func signOut()
    {
        print(Auth.auth().currentUser!)
        try! Auth.auth().signOut()
        print(Auth.auth().currentUser)
        self.user = AppUser(fireBaseUser: FireBaseManager.shared.currentUser!)
        self.mailTextField.isUserInteractionEnabled = true
        self.mailTextField.backgroundColor = UIColor.white
        
        self.passwordTextField.isUserInteractionEnabled = true
        self.passwordTextField.backgroundColor = UIColor.white
        
        self.logInButton.setTitle("Sign in", for: UIControlState.normal)
        self.createAccountButton.setTitle("Create account", for: UIControlState.normal)
        
        self.forgotPasswordButton.isEnabled = true
        self.forgotPasswordButton.isHidden = false
        
    }
    
    
    func moveForward()
    {
        if (user?.userFireBase?.isEmailVerified)!
        {
            self.performSegue(withIdentifier: "tabBarRootSegue", sender: nil)
        }
            
        else
        {
            
            let alertActionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default){
                (_) in
                self.user?.userFireBase?.sendEmailVerification(completion: nil)
                self.dismiss(animated: true, completion: {
                    self.alertVC?.dismiss(animated: true, completion: nil)
                })
                let alertExplanationVC = UIAlertController(title: "To Do", message: "Please leave the application and come back after validated your email adress by following instruction sent to you by email.", preferredStyle: UIAlertControllerStyle.alert)
                let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
                    (_) in
                    
                    self.dismiss(animated: true, completion: {
                        self.alertVC?.dismiss(animated: true, completion: nil)
                    })
                }
                alertExplanationVC.addAction(alertActionOk)
                self.present(alertExplanationVC, animated: true, completion: nil)
            }
            
            let alertActionNo = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
                (_) in
                self.dismiss(animated: true, completion: {
                    self.alertVC?.dismiss(animated: true, completion: nil)
                })
            }
            self.showAlerteVCOkButton(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \((self.user?.userFireBase?.email)!)?", alertAction1: alertActionYes, alertAction2: alertActionNo)
        }
    }
    
    func showAlerteVCOkButton (title: String, message: String, alertAction1: UIAlertAction, alertAction2: UIAlertAction?)
    {
        self.alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction1 = alertAction1
        
        
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

