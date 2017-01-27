//
//  GeneralSelectableTableController.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit

protocol ToggleSelectable {
    func toggle(selected: Bool)
}

extension UITableViewCell: ToggleSelectable {
    func toggle(selected: Bool) {
        assert(false, "override `toggle(selected: Bool)` to use with `GeneralSelectableTableController`")
    }
}

/// requires Cell to override `func toggle(selected: Bool)`

final class GeneralSelectableTableController<CellType: UITableViewCell, DataType: Hashable>: GeneralTableController<CellType, DataType> {
    
    var selectionSource = Set<DataType>()
    
    /// toggle the selected state of the cell
    /// - Returns: selected state of cell after toggle is made true: selected, false: unselected
    func toggleSelection(data: DataType, cell: CellType, indexPath: IndexPath) -> Bool {
        if selectionSource.contains(data) {
            selectionSource.remove(data)
            return false
        } else {
            selectionSource.insert(data)
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectIndex(indexPath.row)
        let cell = tableView.dequeueReusableCellWithClass(CellType.self, forIndexPath: indexPath)!
        let data = dataSource[indexPath.row]
        
        let wasSelected = toggleSelection(data: data, cell: cell, indexPath: indexPath)
        cell.toggle(selected: wasSelected)
        cell.isSelected = false
        tableView.reloadRows(at: [indexPath], with: .none)
        
        didSelectCell(cell, data, indexPath)
    }
    
    override func tableView(_ _tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithClass(CellType.self, forIndexPath: indexPath) else {
            return UITableViewCell()
        }
        let data = dataSource[indexPath.row]
        cellLoaded(cell, data, indexPath)
        let selected = selectionSource.contains(data)
        cell.toggle(selected: selected)
        return cell
    }
    
}
