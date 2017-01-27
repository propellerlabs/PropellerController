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
    
    static var nameSelection: (UITableView) -> StubbedGeneralTableController<NameCell, NameData> = { table in
        let controller = StubbedGeneralTableController<NameCell, NameData>()
        controller.tableView = table
        return controller
    }
}
