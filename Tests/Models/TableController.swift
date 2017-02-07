//
//  TableController.swift
//  PropellerController
//
//  Created by RGfox on 1/27/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit
import PropellerController


struct TableController {
    
    static let sampleData = ["Item one", "Item two"]
    
    typealias NameSelectionType = GeneralTableController<NameCell, NameData>
    typealias StubbedNameSelectionType = StubbedGeneralTableController<NameCell, NameData>
    typealias NameMultiSelectType = GeneralMultiSelectionTableController<NameCell, String>
    
    static var nameSelectionStubbed: (UITableView) -> StubbedNameSelectionType = { table in
        let controller = StubbedNameSelectionType()
        controller.tableView = table
        return controller
    }
    
    static var nameSelection: (UITableView) -> NameSelectionType = { table in
        let controller = NameSelectionType()
        controller.tableView = table
        return controller
    }
    
    static var nameMultiSelection: (UITableView) -> NameMultiSelectType = { table in
        let controller = NameMultiSelectType()
        controller.tableView = table
        controller.setDataSource(sampleData)
        return controller
    }
}
