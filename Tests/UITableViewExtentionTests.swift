//
//  UITableViewExtentionTests.swift
//  PropellerController
//
//  Created by Roy McKenzie on 1/31/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import XCTest
@testable import PropellerController

class UITableViewExtentionTests: XCTestCase {
    
    func testRegisterAndDequeueTableViewCell() {
        let tableView = UITableView(frame: .zero)
        
        let controller = GeneralTableController<NameCell, String>()
        controller.tableView = tableView
        controller.dataSource = ["Test data"]
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = tableView.dequeueReusableCellWithClass(NameCell.self, forIndexPath: indexPath)
        
        XCTAssertNotNil(cell)
    }
    
    func testRegisterAndDequeueTableViewHeaderFooterView() {
        let tableView = UITableView(frame: .zero)
        
        tableView.register(headerFooterViewClass: TestTableViewHeaderFooterView.self)

        let headerView = tableView.dequeueReusableHeaderFooterView(TestTableViewHeaderFooterView.self)
        
        XCTAssertNotNil(headerView)
    }
}
