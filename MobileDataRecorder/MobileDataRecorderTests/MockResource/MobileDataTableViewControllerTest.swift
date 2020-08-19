//
//  MobileDataTableViewControllerTest.swift
//  MobileDataRecorderTests
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import XCTest
import UIKit

@testable import MobileDataRecorder

class MobileDataTableViewControllerTest: XCTestCase {
    var mobileListControllerInstance: MobileDataUsageListTableViewController!
    var reuseIdentifierString = "MobileDataTableViewCell"
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mobileListInstance = storyboard.instantiateViewController(identifier: "MobileDataUsageListTableViewController") as? MobileDataUsageListTableViewController else {
            return XCTFail("Could not instantiate UITableviewcontroller")
        }
        mobileListControllerInstance = mobileListInstance
        mobileListControllerInstance.viewModel = MobileDataListViewModel.init(databaseManager: AppService.MobileDatabaseManager(), networkManager: TestNetworkManager())
        mobileListControllerInstance.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testControllerHasTableView() {
        XCTAssertNotNil(mobileListControllerInstance.tableView,
                        "Controller should have a tableview")
    }
    
    func testControllerRegisterNib() {
        XCTAssertNotNil(self.mobileListControllerInstance.registerNibs())
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(mobileListControllerInstance.tableView.delegate,
                        "Controller should have a tableview delegate")
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(mobileListControllerInstance.tableView.dataSource,
                        "Controller should have a tableview datasource")
    }
    
    func testViewModelPresent() {
        XCTAssertNotNil(mobileListControllerInstance.viewModel, "View model not presented")
    }
    
    func testLoaderPresentInController() {
        XCTAssertNotNil(mobileListControllerInstance.loader,"Loader not presented in view controller")
    }
    
    func testDelegatePropertyViewModel() {
        XCTAssertNotNil(mobileListControllerInstance.viewModel.delegate,"View model delegate property should be nil")
    }
    
    func testTitlePropertyViewController() {
        XCTAssertNotNil(mobileListControllerInstance.title,"View controller title should not empty")
    }
    
    func testShowLoaderMessage() {
        XCTAssertNotNil(mobileListControllerInstance.showLoader())
    }
    
    func testAlertMessage() {
        XCTAssertNotNil(mobileListControllerInstance.showAlertViewWithMessage(alertTitle: "Alert", alertMessage: "Alert message", alertBtn: "OK"))
    }
    
    func testToastMessage() {
        XCTAssertNotNil(mobileListControllerInstance.showMessage("Message"))
    }
    
    func testIfTableViewConformsToTableViewMethods() {
        XCTAssertTrue(mobileListControllerInstance.responds(to: #selector(mobileListControllerInstance.numberOfSections(in:))))
        XCTAssertTrue(mobileListControllerInstance.responds(to: #selector(mobileListControllerInstance.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(mobileListControllerInstance.responds(to: #selector(mobileListControllerInstance.tableView(_:cellForRowAt:))))
        XCTAssertTrue(mobileListControllerInstance.responds(to: #selector(mobileListControllerInstance.tableView(_:viewForHeaderInSection:))))
    }
    
    func testCellForRowMethods() {
        let cell = mobileListControllerInstance.tableView(mobileListControllerInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MobileDataTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "MobileDataTableViewCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
}
