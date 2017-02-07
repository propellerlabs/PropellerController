//
//  GeneralCollectionViewController.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

/// Handles common `UICollectionViewDelegate` and `UICollectionViewDataSource` methods for a `UICollectionView`
///
/// ```swift
///     let controller = GeneralCollectionController<MyCustomCell, String>()
///     controller.collectionView = collectionView
///     controller.setDataSource(["Item One", "Item Two"])
///     controller.willDisplayCell = { cell, data, _ in
///         cell.textLabel.text = data
///     }
/// ```
public final class GeneralCollectionController<CellType: UICollectionViewCell, DataType>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var selectedIndex = -1
    
    var dataSource = [[DataType]]() {
        didSet { collectionView?.reloadData() }
    }
    
    /// The `UICollectionView` to set the `dataSource` and `delegate` on
    public weak var collectionView: UICollectionView! {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.useCellOfType(CellType.self)
        }
    }
    
    // MARK: - Setting DataSource
    
    /// Set the `dataSouce` with an array of `DataType`
    public func setDataSource(_ dataSource: [DataType]) {
        self.dataSource = [dataSource]
    }
    
    /// Set the `dataSource` with an array of `[DataType]`
    /// for use in supporting sectioned `UICollectionView`s
    public func setDataSource(_ dataSource: [[DataType]]) {
        self.dataSource = dataSource
    }
    
    // MARK: - Callbacks
    
    /// Callback that takes `CellType`, `DataType`, `IndexPath` and executes a closure
    /// when a cell is selected
    public var didSelectCell: (CellType, DataType, IndexPath) -> Void = { _, _, _ in }
    
    /// Callback that takes `CellType`, `DataType`, `IndexPath` and executes a closure
    /// when a cell is will be displayed
    public var willDisplayCell: (CellType, DataType, IndexPath) -> Void = { _, _, _ in }
    
    /// Callback that takes `CellType`, `DataType`, `IndexPath` and executes a closure
    /// when a cell is loaded
    public var cellLoaded: (CellType, DataType, IndexPath) -> Void = { _, _, _ in }
    
    /// Callback that takes a section number (`Int`) and executes a closure
    /// that returns a `UIView` for a section's header
    public var headerForSection: (Int) -> UIView? = { _ in return nil }
    
    /// Callback that takes an `IndexPath` and executes a closure
    /// that returns a `CGSize` for the cell at that `IndexPath`
    public var sizeForIndexPath: (IndexPath) -> CGSize = { _ in
        assert(false, "`GeneralCollectionController` requires setting property `sizeForIndex`")
        return .zero
    }
    
    //MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithClass(CellType.self, forIndexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let data = dataSource[indexPath.section][indexPath.row]
        cellLoaded(cell, data, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return sizeForIndexPath(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let displayCell = cell as? CellType else {
            return
        }
        let data = dataSource[indexPath.section][indexPath.row]
        willDisplayCell(displayCell, data, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCellWithClass(CellType.self, forIndexPath: indexPath)!
        let data = dataSource[indexPath.section][indexPath.row]
        didSelectCell(cell, data, indexPath)
    }
}

