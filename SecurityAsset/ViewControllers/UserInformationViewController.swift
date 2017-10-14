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
    {
        didSet
        {
            self.loadViewIfNeeded()
        }
        
    }
    var cellTitle: [String] = ["Firstname", "Lastname","Birthdate"]
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        let tbcv = self.tabBarController as! MyUITabBarController
        self.user = tbcv.user
        
        // Do any additional setup after loading the view.
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
        return 1
    }
    //La méthode ci-dessous est utiliser pour implémenter, et mettre à jours, la table view avec le tableau de data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationUserCell", for: indexPath) as! UserInformationTableViewCell
        
        //        cell.itunesContent = resultItunes?[indexPath.row]
        
        
        return cell
    }
    
}
