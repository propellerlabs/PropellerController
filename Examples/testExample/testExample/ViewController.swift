//
//  ViewController.swift
//  testExample
//
//  Created by RGfox on 2/12/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit
import PropellerController

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var tabController: TableController.NameTableType = {
        return TableController.nameTableController(self.tableView)
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabController.cellLoaded = { _, _, _ in }
    }
}

