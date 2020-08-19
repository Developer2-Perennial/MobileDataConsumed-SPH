//
//  MobileDataTableViewCell.swift
//  MobileDataUsageTests
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import XCTest
import UIKit

@testable import MobileDataRecorder

class MobileDataTableViewCellTest : XCTestCase {
    
    var mobileListControllerInstance: MobileDataUsageListTableViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mobileListInstance = storyboard.instantiateViewController(identifier: "MobileDataListTableViewController") as? MobileDataUsageListTableViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        mobileListControllerInstance = mobileListInstance
        mobileListControllerInstance.viewDidLoad()
        let cellInstance = mobileListControllerInstance.tableView(mobileListControllerInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cellInstance)
        XCTAssertNotNil(cellInstance.contentView)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
