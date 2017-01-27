//
//  UITableView+Extension.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// **NOTE:** `identifier/xibName/classname` must all be identical
    func useCellOfType(_ cellType: UITableViewCell.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    /// **NOTE:** `identifier/xibName/classname` must all be identical
    func dequeueReusableCellWithClass<T>(_ cellType: T.Type, forIndexPath indexPath: IndexPath) -> T? {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            return nil
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ headerFooterViewType: T.Type) -> T? {
        let identifier = String (describing: headerFooterViewType)
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            return nil
        }
        return view
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooterViewClass: T.Type) {
        let identifier = String(describing: headerFooterViewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
