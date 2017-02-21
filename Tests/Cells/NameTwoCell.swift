//
//  NameTwoCell.swift
//  PropellerController
//
//  Created by RGfox on 2/10/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

class NameTwoCell: UITableViewCell {

    @IBOutlet weak var nameTwoLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        nameTwoLabel.text = ""
    }

    
}
