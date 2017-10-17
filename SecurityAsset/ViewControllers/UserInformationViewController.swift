//
//  UserInformationViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 12/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit

class UserInformationViewController: UIViewController, UITableViewDataSource {
    var user: AppUser?
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
        let generalInformationSection = generalInformationArray(appUser: self.user!)
        let adressArraySection = adressArray(appUser: self.user!)
        let groupSection = groupArray(appUser: self.user!)
        self.userProperty = ["General Information": generalInformationSection, "Adress": adressArraySection, "Group": groupSection]
        for (key, value) in userProperty {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
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
        var test = self.objectArray.count
        return self.objectArray.count
    }
    
    // La méthode ci-dessous est utilisée par la méthode suivante
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var test = objectArray[section].sectionObjects.count
        return objectArray[section].sectionObjects.count
    }
    //La méthode ci-dessous est utiliser pour implémenter, et mettre à jours, la table view avec le tableau de data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationUserCell", for: indexPath) as! UserInformationTableViewCell
        
                cell.cellContent = (self.cellTitles[indexPath.section].sectionObjects[indexPath.row], objectArray[indexPath.section].sectionObjects[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var test = objectArray[section].sectionName
        return objectArray[section].sectionName
    }
    
    func groupArray(appUser: AppUser) -> [String]
    {
        var groupArrayToReturn: [String]
        groupArrayToReturn = appUser.group.group
        
        return groupArrayToReturn
    }
    
    func adressArray (appUser: AppUser) -> [String]
    {
        var adressArrayToReturn: [String]
        adressArrayToReturn = [appUser.adress.street, String(appUser.adress.number), String(appUser.adress.mailBox), String(appUser.adress.stateZip), appUser.adress.city, appUser.adress.country]
        return adressArrayToReturn
    }
    
    func generalInformationArray (appUser: AppUser) -> [String]
    {
        var generalInformationArray: [String]
        generalInformationArray = [appUser.firstName, appUser.lastName, appUser.bithDate]
        return generalInformationArray
    }
}
