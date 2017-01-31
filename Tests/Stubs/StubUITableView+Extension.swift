//
//  StubUITableView+Extension.swift
//  PropellerController
//
//  Created by RGfox on 1/27/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// **NOTE:** `identifier/xibName/classname` must all be identical
    func stub_useCellOfType(_ cellType: UITableViewCell.Type) {
        let identifier = String(describing: cellType)
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: identifier)
    }
}
