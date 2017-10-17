//
//  FormFieldTableViewCell.swift
//  SecurityAsset
//
//  Created by michael moldawski on 17/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit

class FormFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLabel: UILabel!
    
    weak var delegate: FormFieldDelegate?
    
    var field: String?{
        didSet{
            self.fieldLabel.text = field!
        }
    }
    

}
protocol FormFieldDelegate: class{
    func formFieldTableViewCell(value: Any, sender: FormFieldTableViewCell)
}
