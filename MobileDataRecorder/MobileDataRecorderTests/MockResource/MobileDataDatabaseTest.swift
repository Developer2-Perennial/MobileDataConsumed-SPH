//
//  MobileDataDatabaseTest.swift
//  MobileDataRecorderTests
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import XCTest
import Foundation

@testable import MobileDataRecorder

class MobileDataDatabaseTest: XCTestCase {
    var dataStoreModelObject: ConsumedDataStoreModel?
    
    override func setUp() {
        dataStoreModelObject = ConsumedDataStoreModel()
        dataStoreModelObject?.model = populateMockResponse()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSaveRecord() {
        let expectedOutput = expectation(description: "Storing data in database success")
        AppService.MobileDatabaseManager().storeDataInDatabase(record: dataStoreModelObject!) { (isSuccess) in
            XCTAssertTrue(isSuccess,"Process failed")
            expectedOutput.fulfill()
        }
        wait(for: [expectedOutput], timeout: 15)
    }
    
    func testRenderDataFromDatabase() {
        let expectedOutput = expectation(description: "Fetching data from database success")
        AppService.MobileDatabaseManager().storeDataInDatabase(record: dataStoreModelObject!) { (isSuccess) in
            let consumeDate = AppService.MobileDatabaseManager().fetchDataFromDatabase()
            if let consumeDate = consumeDate {
                XCTAssertNotEqual(consumeDate.count, 0, "Empty data")
                expectedOutput.fulfill()
            }
        }
        wait(for: [expectedOutput], timeout: 15)
    }
    
    func testClearCacheDataFromDatabse() {
        let expectedOutput = expectation(description: "Clear data from database success")
        AppService.MobileDatabaseManager().clearCacheData { (isSuccess) in
            XCTAssertTrue(isSuccess, "Failed to delete all cache data.")
            expectedOutput.fulfill()
        }
        wait(for: [expectedOutput], timeout: 15)
    }
    
    func testDeleteRecordFromDatabase() {
        let expectedOutput = expectation(description: "Data deleted successfully.")
        AppService.MobileDatabaseManager().storeDataInDatabase(record: dataStoreModelObject!) { (isSuccess) in
            XCTAssertTrue(isSuccess, "Failed to save the record.")
            if let dataStoreObj = dataStoreModelObject {
                let isRecordDelete = AppService.MobileDatabaseManager().deleteDataFromDatabase(record: dataStoreObj)
                XCTAssertTrue(isRecordDelete, "Failed to save the record.")
                expectedOutput.fulfill()
            }
        }
        wait(for: [expectedOutput], timeout: 15)
    }
    
    fileprivate func populateMockResponse() -> MobileDateResponseModel?
    {
        return MockDataService.renderMockJsonData(fileName: "ConsumedMobileDataModel")
    }
}
