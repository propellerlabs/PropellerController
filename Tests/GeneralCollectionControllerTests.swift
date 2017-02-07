//
//  GeneralCollectionControllerTests.swift
//  PropellerController
//
//  Created by Roy McKenzie on 1/31/17.
//  Copyright © 2017 Propeller. All rights reserved.
//

import XCTest
@testable import PropellerController

class GeneralCollectionControllerTests: XCTestCase {
    
    func testDataSourceCellForItem() {
        let expectation = self.expectation(description: "cellLoaded called")
        
        let size = CGSize(width: 100, height: 100)
        let frame = CGRect(origin: .zero, size: size)
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        let controller = GeneralCollectionController<TestCollectionViewCell, String>()
        controller.collectionView = collectionView
        controller.setDataSource(["Item one"])
        controller.sizeForIndexPath = { _ in
            return CGSize(width: 100, height: 100)
        }
        controller.cellLoaded = { _ in
            expectation.fulfill()
        }
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = controller.collectionView(collectionView, cellForItemAt: indexPath)
        
        waitForExpectations(timeout: 1, handler: nil)   
        XCTAssertNotNil(controller.cellLoaded)
        XCTAssertNotNil(cell)
    }
    
    func testDelegateWillDisplay() {
        let expectation = self.expectation(description: "willDisplayCell called")
        
        let size = CGSize(width: 100, height: 100)
        let frame = CGRect(origin: .zero, size: size)
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        let controller = GeneralCollectionController<TestCollectionViewCell, String>()
        controller.collectionView = collectionView
        controller.setDataSource(["Item one"])
        controller.sizeForIndexPath = { _ in
            return CGSize(width: 100, height: 100)
        }
        controller.willDisplayCell = { cell, _, _ in
            cell.backgroundColor = .red
            expectation.fulfill()
        }
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = controller.collectionView(collectionView, cellForItemAt: indexPath)
        controller.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(controller.willDisplayCell)
        XCTAssert(cell.backgroundColor == .red)
    }
    
    func testDelegateDidSelectItem() {
        let expectation = self.expectation(description: "didSelectCell called")
        
        let size = CGSize(width: 100, height: 100)
        let frame = CGRect(origin: .zero, size: size)
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        let controller = GeneralCollectionController<TestCollectionViewCell, String>()
        controller.collectionView = collectionView
        controller.setDataSource(["Item one"])
        controller.sizeForIndexPath = { _ in
            return CGSize(width: 100, height: 100)
        }
        controller.didSelectCell = { cell, _, _ in
            expectation.fulfill()
        }
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
        controller.collectionView(collectionView, didSelectItemAt: indexPath)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(controller.didSelectCell)
        XCTAssertNotNil(controller.sizeForIndexPath)
        XCTAssert(collectionView.indexPathsForSelectedItems?.count == 1)
    }
    
    func testNumberOfSections() {
        let size = CGSize(width: 100, height: 100)
        let frame = CGRect(origin: .zero, size: size)
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        let controller = GeneralCollectionController<TestCollectionViewCell, NameData>()
        controller.collectionView = collectionView
        controller.sizeForIndexPath = { _ in
            return CGSize(width: 100, height: 100)
        }
        controller.setDataSource(testSectionedNames)

        let numberOfSections = collectionView.numberOfSections
        XCTAssert(numberOfSections == testSectionedNames.count)
    }
    
    func testNumberOfRows() {
        let size = CGSize(width: 100, height: 100)
        let frame = CGRect(origin: .zero, size: size)
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        let controller = GeneralCollectionController<TestCollectionViewCell, NameData>()
        controller.collectionView = collectionView
        controller.sizeForIndexPath = { _ in
            return CGSize(width: 100, height: 100)
        }
        controller.setDataSource(testSectionedNames)
        
        let numberOfRowsInFirstSection = collectionView.numberOfItems(inSection: 0)
        XCTAssert(numberOfRowsInFirstSection == testSectionedNames[0].count)
    }
}
