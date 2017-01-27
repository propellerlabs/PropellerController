//
//  GeneralTableController.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit


public class GeneralTableController<CellType: UITableViewCell,
                            DataType>: NSObject, UITableViewDataSource, UITableViewDelegate {

    typealias CallbackType = (CellType, DataType, IndexPath) -> Void
    
    var rowHeight: CGFloat = 44
    var headerHeight: CGFloat = 0
    var flaggedIndex: Int = -1
    var flaggedState: Bool = false
    
    var dynamicRowHeights = false {
        willSet {
            if newValue == true {
                tableView?.rowHeight = UITableViewAutomaticDimension
            }
        }
    }
    
    var dataSource = [DataType]() {
        didSet { tableView?.reloadData() }
    }
    
    public weak var tableView: UITableView! {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            registerCell()
            print(CellType.self)
            tableView?.estimatedRowHeight = 44.0
        }
    }
    
    func registerCell() {
        tableView?.useCellOfType(CellType.self)
    }
    
    //MARK: - Callback on Cell Actions -
    
    var willDisplayCell: CallbackType = { _, _, _ in }
    
    var cellLoaded: CallbackType = { _, _, _ in }
    
    var didSelectCell: CallbackType = { _, _, _ in }
    
    var didDeselectCell: CallbackType = { _, _, _ in }
    
    var didSelectIndex: (Int) -> Void = { _ in }
    
    //MARK: - ScrollViewDelegate Actions -
    
    var viewDidScroll = {}

    //MARK: - header/footer Actions -
    
    var headerForSection: (Int) -> UIView? = { _ in return nil }
    
    var titleForHeaderInSection: (Int) -> String? = { _ in return nil }
    
    var willDisplayHeaderView: (UIView) -> Void = { _ in }
    
    //MARK: - DequeCell - 
    
    func loadCellFrom(table tableView: UITableView, atIndexPath indexPath: IndexPath) -> CellType? {
        return tableView.dequeueReusableCellWithClass(CellType.self, forIndexPath: indexPath)
    }
    
    //MARK: - UITableViewDelegate/DataSource -
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  headerForSection(section)
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dynamicRowHeights ? UITableViewAutomaticDimension : rowHeight
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = loadCellFrom(table: tableView, atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        let data = dataSource[indexPath.row]
        cellLoaded(cell, data, indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectIndex(indexPath.row)
        let cell = loadCellFrom(table: tableView, atIndexPath: indexPath)!
        let data = dataSource[indexPath.row]
        didSelectCell(cell, data, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = loadCellFrom(table: tableView, atIndexPath: indexPath)!
        let data = dataSource[indexPath.row]
        didDeselectCell(cell, data, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CellType else { return }
        let data = dataSource[indexPath.row]
        willDisplayCell(cell, data, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(section)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewDidScroll()
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeaderView(view)
    }
    
    public func scrollToBottom() {
        tableView.layoutIfNeeded()
        tableView.contentOffset.y = tableView.contentSize.height - tableView.frame.height
    }
    
    //disallows tableview scrolling when content is <= height of view to persist messages at bottom instead of top
    public func determineIfTableScrollAllowed() {
        tableView?.layoutIfNeeded()
        if tableView.contentSize.height <= tableView.frame.height {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
    }
}


