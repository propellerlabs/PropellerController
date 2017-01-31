//
//  StubbedGeneralTableController.swift
//  PropellerController
//
//  Created by RGfox on 1/27/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import UIKit
@testable import PropellerController


class StubbedGeneralTableController<CellType:UITableViewCell,DataType>: GeneralTableController<CellType, DataType> {
    func compareMyself(with other: Any?) -> Bool {
        return other is StubbedGeneralTableController
    }
}
