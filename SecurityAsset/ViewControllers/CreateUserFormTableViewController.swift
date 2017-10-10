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
    }
    
    @IBAction func myUnwindCreateUserForm (unwindSegue: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue will be executed")
        if let loginVC = segue.destination as? LogInViewController
        {
            loginVC.user = self.user
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        var rows: Int = 0
//
//        if section < numberOfRowsAtSection.count {
//            rows = numberOfRowsAtSection[section]
//        }
//    
//        return rows
//    }
    
    private func calculateLabelWidth(label: UILabel) -> CGFloat {
        let width = label.frame.width
        
        return width
    }
    
    private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
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
    
    
    private func updateWidthsForLabels(labels: [UILabel]) {
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
    
    func createUser()
    {
        activityIndicator.startAnimating()
        guard let email = mailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let password2 = passwordConfirmationTextField.text else {return}
        let alertActionOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
        {
            (_) in
            self.alertVC?.dismiss(animated: true, completion: nil)
        }
        
        if password == password2
        {
            FireBaseManager.shared.createUser(email: email, password: password)
            { (success) in
                
                if (success)
                {
                   
                   self.user = FireBaseManager.shared.createAppUser(emailTextField: self.mailTextField, firstNameTextField: self.firstNameTextField, lastNameTextField: self.lastNameTextField, groupToJoinOrCreateTextField: self.groupToJoinOrCreateTextField, dateLabel: self.dateLabel, streetTextField: self.streetTextField, streetNumberTextField: self.streetNumberTextField, stateZipTextField: self.stateZipTextField, mailBoxTextField: self.mailBoxTextField, cityTextField: self.cityTextField, countryTextField: self.countryTextField)
                    
                    let alertActionOkSpecial = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
                    {
                        (_) in
                        self.alertVC?.dismiss(animated: true, completion: nil)
                         self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
                    }
                    self.showAlerteVC(title: "User creation", message: "A verifying email has been sent to \(email). Please go to your mail to verify your adress before sign in)", alertAction1: alertActionOkSpecial, alertAction2: nil)
                    
                }
                    
                else
                {
                    guard let errorToDisplay = LogInViewController.fireBaseAuthError else{return}
                    
                    self.showAlerteVC(title: "User creation", message: "\(errorToDisplay.localizedDescription)", alertAction1: alertActionOk, alertAction2: nil)
                    
                    print("user not created")
                }
                self.activityIndicator.stopAnimating()
            }
        }
        else
        {
            
            self.showAlerteVC(title: "User creation", message: "The password and the password confirmation aren't the same!", alertAction1: alertActionOk, alertAction2: nil)
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
    
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
