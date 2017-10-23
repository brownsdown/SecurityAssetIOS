//
//  CreateUserFormTableViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 7/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//
import Foundation
import UIKit

class CreateUserFormTableViewController: UITableViewController {
    
    //MARK:- Attribut
    var user: AppUser?
    //    let numberOfRowsAtSection: [Int] = [7, 6, 1]
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var alertVC: UIAlertController?
    
    @IBOutlet var labels: [UILabel]!
    
    //MARK:- Outlets General information textFields
    @IBOutlet weak var firstNameTextField: UITextField! // ! bypass l'intialisateur et indique que ce n'est pas nil
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var groupToJoinOrCreateTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    var dateSelected: String = ""
    {
        didSet
        {
            dateLabel.text = dateSelected
        }
    }
    
    var alertActionOkSpecial: UIAlertAction? = nil
    var alertActionOk: UIAlertAction? = nil
    //MARK:- Outlets Adress textFields
    
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var streetNumberTextField: UITextField!
    @IBOutlet weak var mailBoxTextField: UITextField!
    @IBOutlet weak var stateZipTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    //MARK:- Buttons outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    //MARK:- Buttons Action
    @IBAction func validateButton(_ sender: UIButton) {
        createUser()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWidthsForLabels(labels: labels)
        cancelButton.layer.cornerRadius = 15
        validateButton.layer.cornerRadius = 15
        dateButton.layer.cornerRadius = 15
        self.initAlertActions()
    }
    
    @IBAction func myUnwindCreateUserForm (unwindSegue: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       super.prepare(for: segue, sender: sender)
        if let loginVC = segue.destination as? LogInViewController
        {
            loginVC.user = self.user
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Cette ligne sert à ne pas hilighité la ligne de la tableview
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    func createUser()
    {
        activityIndicator.startAnimating()
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let password2 = passwordConfirmationTextField.text else {return}
        
        if password == password2
        {
            FireBaseManager.shared.createUser(email: email, password: password)
            { (success) in
                
                if (success)
                {
                    self.user = FireBaseManager.shared.createAppUser(emailTextField: self.mailTextField, firstNameTextField: self.firstNameTextField, lastNameTextField: self.lastNameTextField, groupToJoinOrCreateTextField: self.groupToJoinOrCreateTextField, dateLabel: self.dateLabel, streetTextField: self.streetTextField, streetNumberTextField: self.streetNumberTextField, stateZipTextField: self.stateZipTextField, mailBoxTextField: self.mailBoxTextField, cityTextField: self.cityTextField, countryTextField: self.countryTextField)
                    
                    FireBaseManager.storeUserInDB(appUser: self.user!)
                    
                    self.showAlerteVC(title: "User creation", message: "A verifying email has been sent to \(email). Please go to your mail to verify your adress before sign in)", alertAction1: self.alertActionOkSpecial!, alertAction2: nil)
                }
                    
                else
                {
                    guard let errorToDisplay = LogInViewController.fireBaseAuthError else{return}
                    
                    self.showAlerteVC(title: "User creation", message: "\(errorToDisplay.localizedDescription)", alertAction1: self.alertActionOk!, alertAction2: nil)

                }
                self.activityIndicator.stopAnimating()
            }
        }
        else
        {
            self.showAlerteVC(title: "User creation", message: "The password and the password confirmation aren't the same!", alertAction1: self.alertActionOk!, alertAction2: nil)
        }
        
    }
}
