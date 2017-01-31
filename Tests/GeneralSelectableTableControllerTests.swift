//
//  GeneralSelectableTableControllerTests.swift
//  PropellerController
//
//  Created by Roy McKenzie on 1/31/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import XCTest
@testable import PropellerController

class GeneralSelectableTableControllerTests: XCTestCase {
    
    func testDelegateDidSelectRow() {
        
        let tableView = UITableView(frame: .zero)
        let tableContoller = GeneralSelectableTableController<NameCell, String>()
        tableContoller.tableView = tableView
        tableContoller.dataSource = ["Item one", "Item two"]

        let indexPath = IndexPath(row: 0, section: 0)
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableContoller.tableView(tableView, didSelectRowAt: indexPath)
        
        XCTAssert(tableContoller.selectionSource.count == 1)
    }
    
    func testDelegateDidDeselectRow() {
        
        let tableView = UITableView(frame: .zero)
        let tableController = GeneralSelectableTableController<NameCell, String>()
        tableController.tableView = tableView
        tableController.dataSource = ["Item one", "Item two"]
        
        let indexPath = IndexPath(row: 0, section: 0)
        let indexPath2 = IndexPath(row: 1, section: 0)
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableController.tableView(tableView, didSelectRowAt: indexPath)
        tableView.selectRow(at: indexPath2, animated: false, scrollPosition: .none)
        tableController.tableView(tableView, didSelectRowAt: indexPath2)
        
        XCTAssert(tableController.selectionSource.count == 2)
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableController.tableView(tableView, didDeselectRowAt: indexPath)
        
        XCTAssert(tableController.selectionSource.count == 1)
        XCTAssert(tableController.selectionSource.contains("Item two"))
    }
    
    func testDataSourceCellForRowAtIndexPath() {
        let tableView = UITableView(frame: .zero)
        let tableController = GeneralSelectableTableController<NameCell, String>()
        tableController.tableView = tableView
        tableController.dataSource = ["Item one", "Item two"]
        tableController.cellLoaded = { cell, data, indexPath in
            cell.textLabel?.text = data
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableController.tableView(tableView, cellForRowAt: indexPath)
        
        XCTAssertNotNil(cell)
        XCTAssert(cell.textLabel?.text == "Item one")
    }
    
    func testMultipleSelection() {
        let tableView = UITableView(frame: .zero)
        
        let tableController = GeneralSelectableTableController<NameCell, String>()
        tableController.tableView = tableView
        tableController.allowsMultipleSelection = true
        tableController.dataSource = ["Item one", "Item two"]
 
        let indexPath = IndexPath(row: 0, section: 0)
        let indexPath2 = IndexPath(row: 1, section: 0)
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.selectRow(at: indexPath2, animated: false, scrollPosition: .none)
        tableController.tableView(tableView, didSelectRowAt: indexPath)
        tableController.tableView(tableView, didSelectRowAt: indexPath2)
        
        XCTAssert(tableController.tableView.allowsMultipleSelection == true)
        XCTAssert(tableView.indexPathsForSelectedRows?.count == 2)
        XCTAssert(tableController.selectionSource.contains("Item one"))
        XCTAssert(tableController.selectionSource.contains("Item two"))
        XCTAssert(tableController.selectionSource.count == 2)
    }
    
}
