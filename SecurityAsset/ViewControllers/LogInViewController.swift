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
    let defaults = UserDefaults.standard
    static var fireBaseAuthError: Error?
    var alertVC: UIAlertController?
    var user: AppUser? = nil
    {
        didSet
        {
            mailTextField.text = user?.email
        }
    }
    
    
    
    //MARK:- IBOutlet Properties
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        mailTextField.text = (defaults.value(forKey: "email")) as? String
//      passwordTextField.text = (defaults.value(forKey: "password")) as? String
        super.viewDidLoad()
        logInButton.layer.cornerRadius = 15
        createAccountButton.layer.cornerRadius = 15
        forgotPasswordButton.layer.cornerRadius = 15
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func myUnwindLoginForm (unwindSegue: UIStoryboardSegue){
        
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else{return}
        switch title
        {
        case "Sign in":
            signIn()
        case "Create account":
            goTocreateUser()
        case "Continue":
            moveForward()
        case "Sign out":
            signOut()
        default:
            print("default")
        }
    }
    
    
    
    func signIn()
    {
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (_) in
            self.alertVC?.dismiss(animated: true, completion: nil)
        }
        if password == ""
        {
            self.showAlerteVC(title: "Login", message: "The Password is empty", alertAction1: alertActionOk, alertAction2: nil)
        }
        FireBaseManager.shared.login(email: email, password: password) { (success: Bool) in
            if (success)
            {
                self.user = AppUser(fireBaseUser: FireBaseManager.shared.currentUser!)
                self.mailTextField.isUserInteractionEnabled = false
                self.mailTextField.backgroundColor = UIColor.darkGray
             
                self.defaults.set(self.user?.email, forKey: "email")//
                self.defaults.set(password, forKey: "password")//
                
                self.passwordTextField.isUserInteractionEnabled = false
                self.passwordTextField.backgroundColor = UIColor.darkGray
                
                self.logInButton.setTitle("Continue", for: UIControlState.normal)
                self.createAccountButton.setTitle("Sign out", for: UIControlState.normal)
                if !(self.user?.userFireBase?.isEmailVerified)!
                {
                    self.showAlerteVCMailNotVerified()
                    self.logInButton.isEnabled = false
                    self.logInButton.backgroundColor = UIColor.darkGray
                }
                self.forgotPasswordButton.isEnabled = false
                self.forgotPasswordButton.isHidden = true
                print("login successed")
            }
        }
    }
    
    func goTocreateUser()
    {
        self.performSegue(withIdentifier: "goToCreateUser", sender: nil)
    }
    
    func signOut()
    {
        try! Auth.auth().signOut()
        let currentUSer = Auth.auth().currentUser
        self.user = AppUser(fireBaseUser: currentUSer )
        passwordTextField.text = ""
        
        self.mailTextField.isUserInteractionEnabled = true
        self.mailTextField.backgroundColor = UIColor.white
        
        self.passwordTextField.isUserInteractionEnabled = true
        self.passwordTextField.backgroundColor = UIColor.white
        
        self.logInButton.setTitle("Sign in", for: UIControlState.normal)
        self.logInButton.isEnabled = true
        self.logInButton.backgroundColor = UIColor.white
        
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
    
    func showAlerteVCMailNotVerified ()
    {
        let alertActionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
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
        
        let alertActionNo = UIAlertAction(title: "No", style: UIAlertActionStyle.default) {
            (_) in
            
            self.alertVC?.dismiss(animated: true, completion: nil)
        }
        
        self.showAlerteVC(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \((self.user?.userFireBase?.email)!)?", alertAction1: alertActionYes, alertAction2: alertActionNo)
    }
    
    
}

