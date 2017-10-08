//
//  DatePickerViewController.swift
//  SecurityAsset
//
//  Created by michael moldawski on 8/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var selectedDate: String = ""
    var dateFormatter: DateFormatter = DateFormatter()
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let createUserVC = segue.destination as? CreateUserFormTableViewController
        {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            selectedDate = dateFormatter.string(from: datePicker.date)

            createUserVC.dateSelected = selectedDate

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
