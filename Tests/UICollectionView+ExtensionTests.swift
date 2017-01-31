//
//  UICollectionView+ExtensionTests.swift
//  PropellerController
//
//  Created by Roy McKenzie on 1/30/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import XCTest
@testable import PropellerController

class UICollectionViewExtensionTests: XCTestCase {
    
    func testRegisterCollectionViewCell() {
        let size = CGSize(width: 100, height: 100)
        let frame = CGRect(origin: .zero, size: size)
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        let controller = GeneralCollectionViewController<TestCollectionViewCell, String>()
        controller.collectionView = collectionView
        controller.sizeForIndex = { _ in
            return size
        }
        controller.dataSource = ["Test data"]
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView.dequeueReusableCellWithClass(TestCollectionViewCell.self, forIndexPath: indexPath)
        
        XCTAssertNotNil(cell)
    }
}
