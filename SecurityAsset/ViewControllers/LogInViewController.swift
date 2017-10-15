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
    
    //MARK:- AlertActions
    var alertActionOk: UIAlertAction?
    var alertActionYes: UIAlertAction?
    var alertActionNo: UIAlertAction?
    
    //MARK:- IBOutlet Properties
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        passwordTextField.text = (defaults.value(forKey: "password")) as? String
        mailTextField.text = (defaults.value(forKey: "email")) as? String
        logInButton.layer.cornerRadius = 15
        createAccountButton.layer.cornerRadius = 15
        forgotPasswordButton.layer.cornerRadius = 15
        self.initAlertActions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let myTabBarVC = segue.destination as? MyUITabBarController
        {
            myTabBarVC.user = self.user
        }
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
        
        if password == ""
        {
            self.showAlerteVC(title: "Login", message: "The Password is empty", alertAction1: self.alertActionOk!, alertAction2: nil)
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
//            else
//            {
//                print("test")
//                guard let errorToDisplay = LogInViewController.fireBaseAuthError else{return}
//
//                self.showAlerteVC(title: "User creation", message: "\(errorToDisplay.localizedDescription)", alertAction1: self.alertActionOk!, alertAction2: nil)
//            }
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
        if (user?.userFireBase?.isEmailVerified)! && AppUser.completion == 10
        {
            AppUser.completion = 0
            self.performSegue(withIdentifier: "tabBarRootSegue", sender: nil)
        }
    }
    
    func enableContinueButton()
    {
        self.logInButton.isEnabled = true
    }
    
}

