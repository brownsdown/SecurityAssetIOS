//
//  UserInformationTableViewCell.swift
//  SecurityAsset
//
//  Created by michael moldawski on 12/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit

class UserInformationTableViewCell: UITableViewCell {
    var cellContent: (String,String) = ("","")
    {
        didSet
        {
            self.cellLabel.text = cellContent.0
            self.cellTextField.text = cellContent.1
        }
    }
    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var cellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
