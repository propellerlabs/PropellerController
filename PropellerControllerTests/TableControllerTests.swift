//
//  TableControllerTests.swift
//  PropellerController
//
//  Created by RGfox on 1/26/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import XCTest
import UIKit
@testable import PropellerController

let window = UIApplication.shared.keyWindow

class TableControllerTests: XCTestCase {
    
    func testControllerConformsToDelegateDataSource() {
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        XCTAssert(controller.compareMyself(with: table.delegate),"failed to assign controller as delegate")
        XCTAssert(controller.compareMyself(with: table.dataSource),"failed to assign controller as dataSource")
        XCTAssert(!controller.compareMyself(with: table),"controller is not the same type as the table, that makes no sense")
    }
    
    func testControllerDataSourceSet() {
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.dataSource = testNames
        XCTAssert(controller.dataSource.count == testNames.count)
    }
    
    func testLoadNameCellFromNib() {
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = bundle.loadNibNamed("NameCell", owner: self, options: nil)
        if nib?.first as? NameCell == nil {
            XCTFail("could not load nib NameCell")
        }
    }
    
    func testRowHeightSet() {
        
        let table = UITableView()
        window?.addSubview(table)
        
        let controller = TableController.nameSelection(table)
        controller.dataSource = testNames
        controller.rowHeight = 80
    
        controller.cellLoaded = { cell, data, iPath in
            XCTAssert(iPath.row == 2)
            XCTAssert(iPath.section == 0)
        }
        
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = controller.tableView(table, cellForRowAt: indexPath)
        
        XCTAssert(cell.reuseIdentifier == "NameCell", "Invalid reuseIdentifier \(cell.reuseIdentifier) != \"NameCell\"")
        XCTAssert(cell.frame.height == controller.rowHeight, "wrong cell height: \(cell.frame.height)")
        XCTAssert(controller.dataSource.count == testNames.count)
    }
}
