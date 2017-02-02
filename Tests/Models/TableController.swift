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
    
    static var nameSelectionStubbed: (UITableView) -> StubbedGeneralTableController<NameCell, NameData> = { table in
        let controller = StubbedGeneralTableController<NameCell, NameData>()
        controller.tableView = table
        return controller
    }
    
    static var nameSelection: (UITableView) -> GeneralTableController<NameCell, NameData> = { table in
        let controller = GeneralTableController<NameCell, NameData>()
        controller.tableView = table
        return controller
    }
    
    static var nameMultiSelection: (UITableView) -> GeneralMultiSelectionTableController<NameCell, String> = { table in
        let controller = GeneralMultiSelectionTableController<NameCell, String>()
        controller.tableView = table
        controller.setDataSource(sampleData)
        return controller
    }
}
