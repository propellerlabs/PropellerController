//
//  TableController.swift
//  testExample
//
//  Created by RGfox on 2/12/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import PropellerController

struct TableController {
    
    typealias NameTableType = GeneralTableController<NameCell, NameData>
    
    static var nameTableController: (UITableView) -> NameTableType = { table in
        let controller = NameTableType()
        controller.tableView = table
        controller.setDataSource(testNames)
        
        controller.willDisplayCell = { cell, data, _ in
            cell.nameLabel.text = data.first
        }
        
        controller.didSelectCell = { cell, _, _ in
            cell.backgroundColor = .green
        }
        
        controller.didDeselectCell = { cell, _, _ in
            cell.backgroundColor = .white
        }
        controller.cellTypeForIndexData = { data, iPath in
            if iPath.row % 2 == 0 {
                return NameCell.cellTypeIdentifier
            } else {
                return NameTwoCell.cellTypeIdentifier
            }
        }

        controller.ofCell(type: NameTwoCell.self)
            .cellLoaded = { cell, data, _ in
                cell.nameTwoLabel.text = data.first
                cell.backgroundColor = .orange
        }
        return controller
    }
}

