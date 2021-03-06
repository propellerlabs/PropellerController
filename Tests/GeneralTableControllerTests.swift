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

class GeneralTableControllerTests: XCTestCase {
    
    func testControllerConformsToDelegateDataSource() {
        let table = UITableView()
        let _ = TableController.nameSelection(table)
        XCTAssert(table.delegate is GeneralTableController<NameCell, NameData>,
                  "failed to assign controller as delegate")
        XCTAssert(table.dataSource is GeneralTableController<NameCell, NameData>,
                  "failed to assign controller as dataSource")
    }
    
    func testControllerDataSourceSet() {
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        XCTAssert(controller.dataSource.first != nil)
        XCTAssert(controller.dataSource.first!.count == testNames.count)
    }
    
    func testLoadNameCellFromNib() {
        let bundle = Bundle(for: self.classForCoder)
        let nib = bundle.loadNibNamed("NameCell", owner: self, options: nil)
        if nib?.first as? NameCell == nil {
            XCTFail("could not load nib NameCell")
        }
    }
    
    func testFireCellLoaded() {
        let expectation = self.expectation(description: "should call `cellLoaded`")
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
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
        controller.setDataSource(testNames)
        controller.rowHeight = 80
        
        controller.willDisplayCell = { cell, data, iPath in
            XCTAssert(cell.frame.height == 80, "incorrect cell height on `willDisplayCell`")
        }
        let indexPath = IndexPath(row: 2, section: 0)
        let _ = controller.tableView(table, cellForRowAt: indexPath)
        XCTAssert(controller.tableView(table, heightForRowAt: indexPath) == 80, "incorrect cell height from `heightForRowAt`")
    }
    
    func testSetDynamicRowHeights() {
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        controller.dynamicRowHeights = true
        XCTAssert(table.rowHeight == UITableViewAutomaticDimension, "did not assign dynamic row heights value to tableView")
    }
    
    func testDidSelectCell() {
        let expectation = self.expectation(description: "should call `didSelectCell`")
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        controller.didSelectCell = { cell, data, iPath in
            XCTAssert(data.first == testNames[iPath.row].first)
            XCTAssert(iPath.row == 2)
            XCTAssert(iPath.section == 0)
            expectation.fulfill()
        }
        let index = 2
        let indexPath = IndexPath(row: index, section: 0)
        let data = testNames[index]
        let cell = controller.tableView(table, cellForRowAt: indexPath) as! NameCell
        controller.didSelectCell(cell, data, indexPath)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testDidDeselectCell() {
        let expectation = self.expectation(description: "should call `didSelectCell`")
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        controller.didDeselectCell = { cell, data, iPath in
            XCTAssert(data.first == testNames[iPath.row].first)
            XCTAssert(iPath.row == 2)
            XCTAssert(iPath.section == 0)
            expectation.fulfill()
        }
        let index = 2
        let indexPath = IndexPath(row: index, section: 0)
        let data = testNames[index]
        let cell = controller.tableView(table, cellForRowAt: indexPath) as! NameCell
        controller.didDeselectCell(cell, data, indexPath)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testWillDisplayCell() {
        let expectation = self.expectation(description: "should call `didSelectCell`")
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        controller.willDisplayCell = { cell, data, iPath in
            XCTAssert(data.first == testNames[iPath.row].first)
            XCTAssert(iPath.row == 2)
            XCTAssert(iPath.section == 0)
            expectation.fulfill()
        }
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = controller.tableView(table, cellForRowAt: indexPath)
        let _ = controller.tableView(table, willDisplay: cell, forRowAt: indexPath)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSetTitleForHeaderInSection() {
        let expectation = self.expectation(description: "should call `didSelectCell`")
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        let titleText = "titleTest"
        controller.titleForHeaderInSection = { section in
            XCTAssert(section == 0)
            expectation.fulfill()
            return titleText
        }
        let title = controller.tableView(table, titleForHeaderInSection: 0)
        XCTAssert(title == titleText)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testViewForHeaderInSection() {
        let expectation = self.expectation(description: "should call `didSelectCell`")
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        
        let testHeader = UIView()
        
        controller.headerForSection = { section in
            XCTAssert(section == 0)
            expectation.fulfill()
            return testHeader
        }
        let view = controller.tableView(table, viewForHeaderInSection: 0)
        XCTAssert(testHeader === view)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testWillDisplayHeaderView() {
        let expectation = self.expectation(description: "should call `didSelectCell`")
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        let testHeader = UIView()
        controller.headerForSection = { section in
            XCTAssert(section == 0)
            return testHeader
        }
        controller.willDisplayHeaderView = { view in
            XCTAssert(view === testHeader)
            expectation.fulfill()
        }
        guard let view = controller.tableView(table, viewForHeaderInSection: 0) else {
            XCTFail()
            return
        }
        controller.tableView(table, willDisplayHeaderView: view, forSection: 0)
        XCTAssert(testHeader === view)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    //MARK: - Set CellOptions -
    
    func testManualXib() {
        let expectation = self.expectation(description: "should load cell")
        let identifier = "NameCellB"
        let controller = GeneralTableController<NameAgainCell, NameData>(cellTypeOption: .xibManual(identifier))
        let frame = CGRect(x: 0, y: 0, width: 30, height: 10000)
        let table = UITableView(frame: frame)
        controller.tableView = table
        controller.setDataSource(testNames)
        controller.cellLoaded = { cell, data, iPath in
            XCTAssert(cell.reuseIdentifier == identifier)
            XCTAssert(data.first == testNames[iPath.row].first)
            XCTAssert(iPath.row == 2)
            XCTAssert(iPath.section == 0)
            expectation.fulfill()
        }
        let indexPath = IndexPath(row: 2, section: 0)
        let _ = controller.tableView(table, cellForRowAt: indexPath)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testClassOnlyCell() {
        let expectation = self.expectation(description: "should call `cellLoaded`")
        let identifier = "NameCell"
        let controller = GeneralTableController<NameAgainCell, NameData>(cellTypeOption: .classOnly(identifier))
        let frame = CGRect(x: 0, y: 0, width: 30, height: 10000)
        let table = UITableView(frame: frame)
        controller.tableView = table
        controller.setDataSource(testNames)
        controller.cellLoaded = { cell, data, iPath in
            XCTAssert(cell.reuseIdentifier == identifier)
            XCTAssert(data.first == testNames[iPath.row].first)
            XCTAssert(iPath.row == 2)
            XCTAssert(iPath.section == 0)
            expectation.fulfill()
        }
        let indexPath = IndexPath(row: 2, section: 0)
        let _ = controller.tableView(table, cellForRowAt: indexPath)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    //TODO: - test for storyboard cell -
    
    //MARK: - Tests for Sroll functionality -
    
    func testScrollViewDidScrollCallback() {
        let expectation = self.expectation(description: "should call `didSelectCell`")
        let frame = CGRect(x: 0, y: 0, width: 30, height: 10000)
        let table = UITableView(frame: frame)
        let controller = TableController.nameSelection(table)
        let scrollToPoint = CGPoint(x:0,y:100)
        controller.setDataSource(testNames)
        controller.viewDidScroll = { scrollView in
            XCTAssert(scrollView === table)
            XCTAssert(scrollToPoint == scrollView.contentOffset)
            expectation.fulfill()
        }
        table.setContentOffset(scrollToPoint, animated: false)
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    public func testScrollToBottomHeightMoreThanContentSizeHeight() {
        let expectation = self.expectation(description: "should move scrollView to bottom")
        let frame = CGRect(x: 0, y: 0, width: 30, height: 10000)
        let table = UITableView(frame: frame)
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        
        //test scroll to bottom position, if contentSize < frame height sould just goto to y = 0
        var expectedBottomY = table.contentSize.height - frame.height
        if expectedBottomY < 0 {
            expectedBottomY = 0
        }
        controller.viewDidScroll = { scrollView in
            //should not call scroll, since it should not move 
            //bc height > contentSize && position.y starts at 0
            XCTFail()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (expectedBottomY == frame.origin.y) {
                XCTAssert(table.contentOffset.y == expectedBottomY)
                expectation.fulfill()
            }
        }
        controller.scrollToBottom()
        waitForExpectations(timeout: 2.0, handler: nil)
        table.layoutIfNeeded()
        

    }
    
    public func testScrollToBottomNormalUse() {
        let expectation = self.expectation(description: "should move scrollView to bottom")
        let frame = CGRect(x: 0, y: 0, width: 30, height: 10000)
        let table = UITableView(frame: frame)
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testNames)
        table.contentSize.height = 20000
        
        //test scroll to bottom position, if contentSize < frame height sould just goto to y = 0
        var expectedBottomY = table.contentSize.height - frame.height
        if expectedBottomY < 0 {
            expectedBottomY = 0
        }
        controller.viewDidScroll = { scrollView in
            XCTAssert(scrollView === table)
            XCTAssert(expectedBottomY == scrollView.contentOffset.y)
            expectation.fulfill()
        }
        controller.scrollToBottom()
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testNumberOfSections() {
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testSectionedNames)
        
        let numberOfSections = table.numberOfSections
        XCTAssert(numberOfSections == testSectionedNames.count)
    }
    
    func testNumberOfRows() {
        let table = UITableView()
        let controller = TableController.nameSelection(table)
        controller.setDataSource(testSectionedNames)
        
        let numberOfRowsInFirstSection = table.numberOfRows(inSection: 0)
        XCTAssert(numberOfRowsInFirstSection == testSectionedNames[0].count)
    }
}
