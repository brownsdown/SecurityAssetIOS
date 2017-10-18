//
//  UserInformationViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 12/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit

class UserInformationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FormFieldDelegate{
    var user: AppUser?
    
    var formFields: [FormFieldType] = [.street, .number, .mailbox, .stateZip, .city, .country, .firstName, .lastName, .birthdate, .group]
    var values = [String]()
    let attributNotIncluded = ["userState", "email", "location", "phonePosition","userFireBase"]
    var objectArray = [Objects]()
    var userProperty: [String: [String]] = [:]
    var cellTitles: [Objects] = [Objects(sectionName: "Adress",sectionObjects: ["Street","Number","Mail box","State Zip","City","Country"]), Objects(sectionName: "General Information",sectionObjects: ["First name","Last name","Birthdate"]), Objects(sectionName: "Group",sectionObjects: ["group1","group2","group3","group4"])]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
  
    }
    
    @IBAction func returnToLogin(_ sender: Any) {
        self.dismiss(animated: true) {}
        self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark : - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // La méthode ci-dessous est utilisée par la méthode suivante
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formFields.count
    }
    //La méthode ci-dessous est utiliser pour implémenter, et mettre à jours, la table view avec le tableau de data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let field = formFields[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationUserCell", for: indexPath) as! FormFieldTableViewCell
        
        cell.field = field.rawValue
        cell.delegate = self
        return cell
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return objectArray[section].sectionName
//    }
    

    @IBAction func saveAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func updateUserInformation(value: Any, sender: FormFieldTableViewCell)
    {
        //TODO
    }
}

enum FormFieldType: String{
    case street = "Street"
    case number = "Number"
    case mailbox = "Mail box"
    case stateZip = "State Zip"
    case city = "City"
    case country = "Country"
    case firstName = "Firstname"
    case lastName = "Lastname"
    case birthdate = "Birthdate"
    case group = "group1"
    }


