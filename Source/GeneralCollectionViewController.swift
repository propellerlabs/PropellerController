//
//  GeneralCollectionViewController.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

final class GeneralCollectionViewController<CellType: UICollectionViewCell, DataType>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var selectedIndex = -1
    
    var dataSource = [[DataType]]() {
        didSet { collectionView?.reloadData() }
    }
    
    public func setDataSource(_ dataSource: [DataType]) {
        self.dataSource = [dataSource]
    }
    
    public func setDataSource(_ dataSource: [[DataType]]) {
        self.dataSource = dataSource
    }
    
    weak var collectionView: UICollectionView! {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.useCellOfType(CellType.self)
        }
    }
    
    var didSelectIndex: (Int) -> Void = { _ in }
    
    var didSelectCell: (CellType, DataType, IndexPath) -> Void = { _, _, _ in }
    
    var willDisplayCell: (CellType, DataType, IndexPath) -> Void = { _, _, _ in }
    
    var cellLoaded: (CellType, DataType, IndexPath) -> Void = { _, _, _ in }
    
    var headerForSection: (Int) -> UIView? = { _ in return nil }
    
    var sizeForIndex: (Int) -> CGSize = { _ in
        assert(false, "`GeneralCollectionController` requires setting property `sizeForIndex`")
        return .zero
    }
    
    var numberOfItemsInSection: (Int) -> Int? = { _ in return nil }
    
    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section) ?? dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithClass(CellType.self, forIndexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let data = dataSource[indexPath.section][indexPath.row]
        cellLoaded(cell, data, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return sizeForIndex(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let displayCell = cell as? CellType else {
            return
        }
        let data = dataSource[indexPath.section][indexPath.row]
        willDisplayCell(displayCell, data, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectIndex(indexPath.row)
        let cell = collectionView.dequeueReusableCellWithClass(CellType.self, forIndexPath: indexPath)!
        let data = dataSource[indexPath.section][indexPath.row]
        didSelectCell(cell, data, indexPath)
    }
}

