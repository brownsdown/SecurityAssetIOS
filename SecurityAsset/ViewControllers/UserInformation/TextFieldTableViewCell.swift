//
//  TextFieldTableViewCell.swift
//  SecurityAsset
//
//  Created by michael moldawski on 17/10/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: FormFieldTableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textField.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = self.field else {return}
        self.delegate?.formFieldTableViewCell(value: textField.text ?? "", sender: self)
    }

}
