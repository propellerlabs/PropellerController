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
    
    func testFireCellLoaded() {
        
        let table = UITableView()
        
        let controller = TableController.nameSelection(table)
        controller.dataSource = testNames
        controller.rowHeight = 80
        let expectation = self.expectation(description: "Resource should return completion")
        controller.cellLoaded = { cell, data, iPath in
            XCTAssert(data.first == testNames[iPath.row].first)
            XCTAssert(iPath.row == 2)
            XCTAssert(iPath.section == 0)
            expectation.fulfill()
        }
        
        let indexPath = IndexPath(row: 2, section: 0)
        let _ = controller.tableView(table, cellForRowAt: indexPath)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCellHeight() {
        
        let table = UITableView()
        
        let controller = TableController.nameSelection(table)
        controller.dataSource = testNames
        controller.rowHeight = 80
        
        controller.willDisplayCell = { cell, data, iPath in
            XCTAssert(cell.frame.height == 80, "incorrect cell height on `willDisplayCell`")
        }
        let indexPath = IndexPath(row: 2, section: 0)
        let _ = controller.tableView(table, cellForRowAt: indexPath)
        XCTAssert(controller.tableView(table, heightForRowAt: indexPath) == 80, "incorrect cell height from `heightForRowAt`")
    }
}
