//
//  GeneralTableController.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

/// Option enum to determine what time of cell registering and dequeueing to use
public enum ControllerCellTypeOption {
    /// UITableView cell subclassed with no xib or storyboard, `customIdentifier` 
    /// required in initializer
    case classOnly
    /// UITableView cell from storyboard, `customIdentifier` required in `GeneralTableController` 
    /// initializer
    case storyboard
    /// UITableView cell subclassed with xib file that has matching names across class name, 
    /// xib file name, and reuseIdentifier.
    case xibAuto
    /// UITableView cell subclassed with xib, where xib and class have matching names, 
    /// but the identifier is different and is required in `GeneralTableController` initizier.
    case xibManual
}

/// Generic TableView Controller requiring Cell and Data associated types to be specified.
/// Define class like so: `GeneralTableController<SomeCellType, SomeDataType>`.
/// Using as below:
///
/// ```swift
/// static var nameSelection: (UITableView) -> GeneralTableController<NameCell, NameData> = { table in
///    let controller = GeneralTableController<NameCell, NameData>()
///    controller.tableView = table
///
///    controller.willDisplayCell = { cell, data, iPath in
///        cell.name = data.first
///        cell.image.asyncSetImage(data.imagePath)
///        cell.location = "row:" + iPath.row
///    }
///    return controller
/// }
/// ```

protocol TableControllable: class, UITableViewDelegate, UITableViewDataSource {
    var cellType: Any.Type { get }
    var dataSourceAny: [[Any]] { get }
}

open class GeneralTableController<CellType: UITableViewCell,
                            DataType>: NSObject, UITableViewDataSource, UITableViewDelegate, TableControllable {

    /// Typealias for common tableView callback closure
    public typealias CallbackType = (CellType, DataType, IndexPath) -> Void
    
    //MARK: - Multiple Cell Configuration -
    
    /// Pass in CellType for a subController configured for that Cell type
    @discardableResult
    public func ofCell<T: UITableViewCell>(type: T.Type) -> GeneralTableController<T, DataType> {
        let identifier = String(describing: T.self)
        return genericTableControllerFor(identifier: identifier)
    }
    
    /// function that determines which cell for `Data` and `IndexPath` 
    /// return cell using stringified using extension proeprty `.cellTypeIdentifier`
    public var cellTypeForIndexData: (DataType, IndexPath) -> String? = { _, _ in
        return nil
    }
    
    var cellType: Any.Type {
        return CellType.self
    }
    
    var dataSourceAny: [[Any]] {
        return dataSource.map({ $0.flatMap({ val in val as Any })})
    }
    
    weak var parentController: TableControllable?
    
    func dataMirror(parentController: TableControllable) {
        self.parentController = parentController
    }
    
    var subControllers = [String: TableControllable]()
    
    func genericTableControllerFor<T>(identifier: String) -> GeneralTableController<T, DataType> {
        //check if exists
        if let controller = subControllers[identifier] {
            return controller as! GeneralTableController<T, DataType>
        }
        //create controller
        let controller = GeneralTableController<T, DataType>()
        controller.registerCell(tableView: tableView)
        controller.dataMirror(parentController: self)
        
        subControllers[identifier] = controller
        return controller
    }
    
    func tableControllableFor(identifier: String) -> TableControllable? {
        return subControllers[identifier]
    }
    
    var cellTypeIdentifier: String {
        return String(describing: CellType.self)
    }
    
    ///MARK: - Properties -
    
    /// Row height for each cell
    public var rowHeight: CGFloat = 44
    
    /// Height for header view
    public var headerHeight: CGFloat = 0
    
    /// Saved index for keeping track of a position or value related to the contents
    public var flaggedIndex: Int = -1
    
    /// Saved boolean state for table
    public var flaggedState: Bool = false
    
    var cellTypeOption: ControllerCellTypeOption = .xibAuto
    var customIdentifier: String?
    
    /// Flag to indicate whether to use dynamic row height calculations
    public var dynamicRowHeights = false {
        willSet {
            if newValue == true {
                tableView?.rowHeight = UITableViewAutomaticDimension
            }
        }
    }
    
    /// dataSource for table, should not be set directly, instead use `setDataSource(_:)`
    var _dataSource = [[DataType]]() {
        didSet { tableView?.reloadData() }
    }
    var dataSource: [[DataType]] {
        if let parent = parentController {
            return parent.dataSourceAny.map({ $0.flatMap({val in val as? DataType})})
        } else {
            return _dataSource
        }
    }
    
    /// set dataSource for tableView from array type
    public func setDataSource(_ dataSource: [DataType]) {
        _dataSource = [dataSource]
    }
    
    /// set dataSource for tableView from nested array type
    public func setDataSource(_ dataSource: [[DataType]]) {
        _dataSource = dataSource
    }
    
    /// tableView to be controlled, setup on tableView is called automatically for delegate,
    /// dataSource, cell registration, after this value is set
    public weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        registerCell(tableView: tableView)
        tableView?.estimatedRowHeight = 44.0
    }
    
    /** Initialize controller with cellOptions and identifier is needed
     
    - Parameters:
        - cellTypeOptions: ControllerCellTypeOption value to indicate how to 
     handle cell registration and dequeue. defaults to `.xibAuto`
        - customIdentifier: if `cellTypeOptions` is set to `.xibAuto` field can be nil;
    */
    public convenience init(cellTypeOption: ControllerCellTypeOption = .xibAuto,
                            customIdentifier: String? = nil) {
        self.init()
        self.cellTypeOption = cellTypeOption
        self.customIdentifier = customIdentifier
    }
    
    //MARK: - Callback on Cell Actions -
    
    /// Callback parameter for when `tableView(_:willDisplayCell:forRowAt)` function is called.
    /// - Closure parameters include: `CellType, DataType, IndexPath`
    public var willDisplayCell: CallbackType = { _, _, _ in }
    
    /// Callback parameter for when `tableView(_:cellForRowAt:)` function is called.
    /// - Closure parameters include: `CellType, DataType, IndexPath`
    public var cellLoaded: CallbackType = { _, _, _ in }
    
    /// Callback parameter for when `tableView(_:didSelectRowAt:)` function is called.
    /// - Closure parameters include: `CellType, DataType, IndexPath`
    public var didSelectCell: CallbackType = { _, _, _ in }

    /// Callback parameter for when `tableView(_:didDeselectRowAt:)` function is called.
    /// - Closure parameters include: `CellType, DataType, IndexPath`
    public var didDeselectCell: CallbackType = { _, _, _ in }
    
    //MARK: - ScrollViewDelegate Actions -
    
    /// Callback parameter for `UIScrollViewDelegate` called when tableView is scrolled
    /// - Closure parameters: `UIScrollView` that was scrolled on
    public var viewDidScroll: (UIScrollView) -> Void = { _ in }
    
    //MARK: - header/footer Actions -
    
    /** 
     Callback function that returns the header view for a particular section
     
     - Closure parameters:
        - (Int) section: section number to get view for
       
     - Returns: `UIView` for section passed in via parameter.
    */
    public var headerForSection: (Int) -> UIView? = { _ in return nil }

    /**
     Callback function that returns the title string for a particular section
     
     - Closure parameters:
        - (Int) section: section number to get view for
     
     - Returns: title `String` for section passed in via parameter.
     */
    public var titleForHeaderInSection: (Int) -> String? = { _ in return nil }
    
    /**
     Callback function that gives you header view for configurations right before it is displayed
     
     - Closure parameters:
     - (UIView) headerView: header view that will be displayed

     */
    public var willDisplayHeaderView: (UIView) -> Void = { _ in }
    
    //MARK: - Cells -
    
    func registerCell(tableView: UITableView?) {
        guard let tableView = tableView else {
            return
        }
        switch cellTypeOption {
        case .xibAuto:
            tableView.useCellOfType(CellType.self)
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
        return dataSource[section].count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func routeTableController(data: DataType, indexPath: IndexPath) -> TableControllable? {
        guard let identifier = cellTypeForIndexData(data, indexPath) else {
            return nil
        }
        return subControllers[identifier]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.section][indexPath.row]
        if let route = routeTableController(data: data, indexPath: indexPath) {
            return route.tableView(tableView, cellForRowAt: indexPath)
        }
        guard let cell = loadCellFrom(table: tableView,
                                      atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        cellLoaded(cell, data, indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.section][indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) as? CellType else {
            //Reroute to correct controller
            if let route = routeTableController(data: data, indexPath: indexPath) {
                route.tableView?(tableView, didSelectRowAt: indexPath)
            }
            return
        }
        didSelectCell(cell, data, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.section][indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) as? CellType else {
            //Reroute to correct controller
            if let route = routeTableController(data: data, indexPath: indexPath) {
                route.tableView?(tableView, didDeselectRowAt: indexPath)
            }
            return
        }
        didDeselectCell(cell, data, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellValue = cell as? CellType else {
            //Reroute to correct controller
            let identifier = "\(type(of: cell))"
            subControllers[identifier]?.tableView?(tableView,
                                                   willDisplay: cell,
                                                   forRowAt: indexPath)
            return
        }
        let data = dataSource[indexPath.section][indexPath.row]
        willDisplayCell(cellValue, data, indexPath)
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
    
    /// Scrolls tableView to last item in table.  If the height of your table is greater than the contentSize
    /// you simple goto top of table (y = 0 position).
    public func scrollToBottom() {
        tableView.layoutIfNeeded()
        let target = tableView.contentSize.height - tableView.frame.height
        tableView.contentOffset.y = target < 0 ? 0 : target
    }
}

extension UITableViewCell {
    
    public static var cellTypeIdentifier: String {
        return String(describing: self.self)
    }
    
}
