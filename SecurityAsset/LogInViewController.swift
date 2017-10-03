//
//  ViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 2/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit


class LogInViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
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


}

