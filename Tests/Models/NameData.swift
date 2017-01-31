//
//  NameData.swift
//  PropellerController
//
//  Created by RGfox on 1/27/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import Foundation

struct NameData {
    let first: String
    let last: String?
    
    init(first: String, last: String? = nil) {
        self.first = first
        self.last = last
    }
}

let testNames = [
        NameData(first: "Bob"),
        NameData(first: "Rob"),
        NameData(first: "Cob"),
        NameData(first: "Dob"),
        NameData(first: "Knob")
]
