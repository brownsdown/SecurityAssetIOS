//
//  MapUserTableViewCell.swift
//  SecurityAsset
//
//  Created by michael moldawski on 7/11/17.
//  Copyright © 2017 michael moldawski. All rights reserved.
//

import UIKit

class MapUserTableViewCell: UITableViewCell{

    var user: AppUser? = nil
    {
        didSet
        {
            self.userNameLabel.text = user?.firstName
            if user?.userState.rawValue == "Unsafe"
            {
                self.backgroundColor = UIColor.red
            }
            else
            {
                self.backgroundColor = nil
            }
        }
    }

    
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol MapUserDelegate: class{
    func centerOnUser(user: AppUser)
}
