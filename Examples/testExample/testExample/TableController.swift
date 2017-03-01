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
        controller.setDataSource(testNames + testNames)
        
        
        //which cell to choose
        controller.cellTypeForIndexData = { data, iPath in
            switch iPath.row % 3 {
            case 1: return NameTwoCell.typeIdentifier
            case 2: return NameAgainCell.typeIdentifier
            default: return NameCell.typeIdentifier
            }
        }

        //cell 1
        controller.willDisplayCell = { cell, data, _ in
            cell.nameLabel.text = data.first
        }
        
        controller.didSelectCell = { cell, _, _ in
            cell.backgroundColor = .green
        }
        
        controller.didDeselectCell = { cell, _, _ in
            cell.backgroundColor = .white
        }

        //cell 2
        controller.ofCell(type: NameTwoCell.self)
            .cellLoaded = { cell, data, _ in
                cell.nameTwoLabel.text = data.first
                cell.backgroundColor = .orange
        }
        
        controller.ofCell(type: NameTwoCell.self)
            .willDisplayCell = { cell, data, _ in
                cell.nameTwoLabel.text = data.first
                cell.backgroundColor = .orange
        }
        
        controller.ofCell(type: NameTwoCell.self)
            .didSelectCell = { cell, data, _ in
                print(data)
        }
        controller.ofCell(type: NameTwoCell.self)
            .didDeselectCell = { cell, data, _ in
                print(data)
        }
        
        
        //cell 3
        controller.ofCell(type: NameAgainCell.self,
                          cellTypeOption: .xibManual("NameCellB"))
            .cellLoaded = { cell, data, _ in
                cell.nameAgainLabel.text = data.first
                cell.backgroundColor = .orange
        }
        
        controller.ofCell(type: NameAgainCell.self)
            .willDisplayCell = { cell, data, _ in
                cell.nameAgainLabel.text = data.first
                cell.backgroundColor = .orange
        }
        
        controller.ofCell(type: NameAgainCell.self)
            .didSelectCell = { cell, data, _ in
                print(data)
        }
        controller.ofCell(type: NameAgainCell.self)
            .didDeselectCell = { cell, data, _ in
                print(data)
        }
        return controller
    }

}

