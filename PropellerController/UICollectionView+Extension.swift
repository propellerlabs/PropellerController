//
//  UICollectionView+Extension.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /// **NOTE:** `identifier/xibName/classname` must all be identical
    func useCellOfType(_ cellType: UICollectionViewCell.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    /// **NOTE:** `identifier/xibName/classname` must all be identical
    func dequeueReusableCellWithClass<T>(_ cellType: T.Type, forIndexPath indexPath: IndexPath) -> T? {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}
