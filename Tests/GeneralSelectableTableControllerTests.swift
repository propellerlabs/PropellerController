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
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableController.tableView(tableView, didSelectRowAt: indexPath)
        
        XCTAssert(tableController.selectionSource.count == 1)
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableController.tableView(tableView, didDeselectRowAt: indexPath)
        
        XCTAssert(tableController.selectionSource.count == 0)
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

        
        let indexPathOne = IndexPath(row: 0, section: 0)
        let indexPathTwo = IndexPath(row: 1, section: 0)
        
        tableView.selectRow(at: indexPathOne, animated: false, scrollPosition: .none)
        tableView.selectRow(at: indexPathTwo, animated: false, scrollPosition: .none)
        tableController.tableView(tableView, didSelectRowAt: indexPathOne)
        tableController.tableView(tableView, didSelectRowAt: indexPathTwo)
        
        XCTAssert(tableController.tableView.allowsMultipleSelection == true)
        XCTAssert(tableView.indexPathsForSelectedRows?.count == 2)
        XCTAssert(tableController.selectionSource.count == 2)
    }
    
}
