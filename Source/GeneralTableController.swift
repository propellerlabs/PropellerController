//
//  GeneralTableController.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

public enum ControllerCellTypeOption {
    case classOnly
    case storyboard
    case xibAuto
    case xibManual
}

public class GeneralTableController<CellType: UITableViewCell,
                            DataType>: NSObject, UITableViewDataSource, UITableViewDelegate {

    public typealias CallbackType = (CellType, DataType, IndexPath) -> Void
    
    public var rowHeight: CGFloat = 44
    public var headerHeight: CGFloat = 0
    
    var flaggedIndex: Int = -1
    var flaggedState: Bool = false
    
    var cellTypeOption: ControllerCellTypeOption = .xibAuto
    var customIdentifier: String?
    
    public var dynamicRowHeights = false {
        willSet {
            if newValue == true {
                tableView?.rowHeight = UITableViewAutomaticDimension
            }
        }
    }
    
    var dataSource = [[DataType]]() {
        didSet { tableView?.reloadData() }
    }
    
    public func setDataSource(_ dataSource: [DataType]) {
        self.dataSource = [dataSource]
    }
    public func setDataSource(_ dataSource: [[DataType]]) {
        self.dataSource = dataSource
    }
    
    public weak var tableView: UITableView! {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            registerCell()
            tableView?.estimatedRowHeight = 44.0
        }
    }

    public convenience init(cellTypeOption: ControllerCellTypeOption = .xibAuto,
                            customIdentifier: String? = nil) {
        self.init()
        self.cellTypeOption = cellTypeOption
        self.customIdentifier = customIdentifier
    }
    
    func registerCell() {
        switch cellTypeOption {
        case .xibAuto:
            tableView?.useCellOfType(CellType.self)
        case .xibManual:
            guard let identifier = customIdentifier else {
                assert(false, ".xibManual requires cell `customIdentifier` ")
                return
            }
            tableView.useCellOfType(CellType.self, customIdentifier: identifier)
        case .classOnly, .storyboard:
            guard let identifier = customIdentifier else {
                assert(false, "\(cellTypeOption) requires cell `customIdentifier` ")
                return
            }
            tableView.register(CellType.self, forCellReuseIdentifier: identifier)
        }
    }
    
    //MARK: - Callback on Cell Actions -
    
    public var willDisplayCell: CallbackType = { _, _, _ in }
    
    public var cellLoaded: CallbackType = { _, _, _ in }
    
    public var didSelectCell: CallbackType = { _, _, _ in }
    
    public var didDeselectCell: CallbackType = { _, _, _ in }
    
    public var didSelectIndex: (Int) -> Void = { _ in }
    
    //MARK: - ScrollViewDelegate Actions -
    
    public var viewDidScroll:(UIScrollView) -> Void = { _ in }

    //MARK: - header/footer Actions -
    
    public var headerForSection: (Int) -> UIView? = { _ in return nil }
    
    public var titleForHeaderInSection: (Int) -> String? = { _ in return nil }
    
    public var willDisplayHeaderView: (UIView) -> Void = { _ in }
    
    //MARK: - DequeCell - 
    
    func loadCellFrom(table tableView: UITableView, atIndexPath indexPath: IndexPath) -> CellType? {
        switch cellTypeOption {
        case .xibAuto:
            return tableView.dequeueReusableCellWithClass(CellType.self, forIndexPath: indexPath)
        case .classOnly, .storyboard, .xibManual:
            guard let identifier = customIdentifier else {
                assert(false, "\(cellTypeOption) requires cell `customIdentifier`")
                return nil
            }
            return tableView.dequeueReusableCell(withIdentifier: identifier) as? CellType
        }
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
        let data = dataSource[indexPath.section][indexPath.row]
        cellLoaded(cell, data, indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectIndex(indexPath.row)
        let cell = loadCellFrom(table: tableView, atIndexPath: indexPath)!
        let data = dataSource[indexPath.section][indexPath.row]
        didSelectCell(cell, data, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = loadCellFrom(table: tableView, atIndexPath: indexPath)!
        let data = dataSource[indexPath.section][indexPath.row]
        didDeselectCell(cell, data, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CellType else { return }
        let data = dataSource[indexPath.section][indexPath.row]
        willDisplayCell(cell, data, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection(section)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewDidScroll(scrollView)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeaderView(view)
    }
    
    public func scrollToBottom() {
        tableView.layoutIfNeeded()
        let target = tableView.contentSize.height - tableView.frame.height
        tableView.contentOffset.y = target < 0 ? 0 : target
    }
}
