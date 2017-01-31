//
//  GeneralSelectableTableController.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

/// requires Cell to override `func toggle(selected: Bool)`

public final class GeneralSelectableTableController<CellType: UITableViewCell, DataType: Hashable>: GeneralTableController<CellType, DataType> {
    
    var selectionSource = Set<DataType>()
    
    public var allowsMultipleSelection = false {
        didSet {
            tableView?.allowsMultipleSelection = allowsMultipleSelection
        }
    }
    
    /// toggle the selected state of the associated cell data in `selectionSource`
    func toggleSelection(data: DataType, cell: CellType, indexPath: IndexPath) {
        if selectionSource.contains(data) {
            selectionSource.remove(data)
        } else {
            selectionSource.insert(data)
        }
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectIndex(indexPath.row)
        guard let cell = loadCellFrom(table: tableView, atIndexPath: indexPath) else {
            return
        }
        
        let data = dataSource[indexPath.row]
        
        toggleSelection(data: data, cell: cell, indexPath: indexPath)
        
        didSelectCell(cell, data, indexPath)
    }
    
    public override func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = loadCellFrom(table: tableView, atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        let data = dataSource[indexPath.row]
        
        let selected = selectionSource.contains(data)
        cell.setSelected(selected, animated: false)
        
        cellLoaded(cell, data, indexPath)
        return cell
    }
}
