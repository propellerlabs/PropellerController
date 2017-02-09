//
//  GeneralSelectableTableController.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

/// Subclass of `GeneralTableController` that allows you you keep track of selected dataSource entry. Requires `DataType` to be `Hashable`.
/// Also, you can use `toggleSelection` function to manually invert a data value's selection state.
open class GeneralMultiSelectionTableController<CellType: UITableViewCell, DataType: Hashable>: GeneralTableController<CellType, DataType> {
    
    /// current selected items
    public var selectionSource = Set<DataType>()
    
    override func setupTableView() {
        super.setupTableView()
        tableView.allowsMultipleSelection = true
    }
    
    /// toggle the selected state of the associated cell data in `selectionSource`
    func toggleSelection(data: DataType) {
        if selectionSource.contains(data) {
            selectionSource.remove(data)
        } else {
            selectionSource.insert(data)
        }
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = loadCellFrom(table: tableView, atIndexPath: indexPath) else {
            return
        }
        let data = dataSource[indexPath.section][indexPath.row]
        toggleSelection(data: data)
        didSelectCell(cell, data, indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = loadCellFrom(table: tableView, atIndexPath: indexPath) else {
            return
        }
        let data = dataSource[indexPath.section][indexPath.row]
        toggleSelection(data: data)
        didDeselectCell(cell, data, indexPath)
    }
    
    public override func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = loadCellFrom(table: tableView, atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        let data = dataSource[indexPath.section][indexPath.row]
        let selected = selectionSource.contains(data)
        cell.setSelected(selected, animated: false)
        cellLoaded(cell, data, indexPath)
        return cell
    }
}
