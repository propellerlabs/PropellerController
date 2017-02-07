//
//  UICollectionView+Extension.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /// Registers a cell using a cell class type and xib with a matching name
    /// - Parameters:
    ///     - cellType: Class name for cell type to register
    /// - Note: `identifier`, `xibName`, `classname` must all be identical
    public func useCellOfType<T: UICollectionViewCell>(_ cellType: T.Type) {
        let identifier = String(describing: cellType)
        let bundle = Bundle(for: cellType.classForCoder())
        let nib = UINib(nibName: identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    /// Dequeue's a cell using a cell class type for a given `IndexPath`
    /// - Parameters:
    ///     - cellType: Class name for cell type to dequeue
    ///     - forIndexPath: IndexPath to dequeue cell for
    /// - Note: `identifier`, `xibName`, `classname` must all be identical
    public func dequeueReusableCellWithClass<T: UICollectionViewCell>(_ cellType: T.Type, forIndexPath indexPath: IndexPath) -> T? {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}
