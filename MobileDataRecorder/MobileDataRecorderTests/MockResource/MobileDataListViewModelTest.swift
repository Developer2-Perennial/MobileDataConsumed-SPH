//
//  MobileDataListViewModel.swift
//  MobileDataUsageTests
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import XCTest
import Foundation
import Alamofire

@testable import MobileDataRecorder

class MobileDataListViewModelTest: XCTestCase {
    
    var mobileDataListViewModel: MobileDataListViewModel!
    var networkService : NetworkManagerService!
    var dbService : DatabaseManagerService!
    
    override func setUp() {
        networkService = TestNetworkManager()
        dbService = AppService.MobileDatabaseManager()
        mobileDataListViewModel = MobileDataListViewModel(databaseManager: dbService, networkManager: networkService)
        let mobileDataResponseModel = populateMockResponse()
        if let mobileDataReponse = mobileDataResponseModel {
            mobileDataListViewModel.bindDataToViewModel(consumedData: mobileDataReponse)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testScreenTitle() {
        XCTAssertEqual(mobileDataListViewModel.constantString.screenTitle, "Mobile Data Usage", "Invalid screen title")
    }
    
    func testDataSearchAPIString() {
        XCTAssertEqual(mobileDataListViewModel.constantString.dataStoreSearch, "datastore_search", "Invalid data search")
    }
    
    func testProcessString() {
        XCTAssertEqual(mobileDataListViewModel.constantString.processingLablTitle, "Processing..", "Invalid processing string")
    }
    
    func testOKButtonTitle() {
        XCTAssertEqual(mobileDataListViewModel.constantString.okButtonTitle, "OK", "Invalid ok button string")
    }
    
    func testNoInternetConnectionTitleString() {
        XCTAssertEqual(mobileDataListViewModel.constantString.noInternetConnection, "No internet connection", "Invalid no internet connection")
    }
    
    func testHeightOfTableViewCell() {
        XCTAssertEqual(mobileDataListViewModel.constantString.tableViewCellHeight, 60)
    }
    
    func testInternetConnection() {
        let networkService = AppService.NetworkManager()
        let isInternetConnection = networkService.checkIfInternetIsActive()
        XCTAssertTrue(isInternetConnection, "Active internet connection")
    }
    
    func testAppURL() {
        XCTAssertEqual(MobileDataConstant.ServerBaseURL, "https://data.gov.sg/api/action/", "App base url")
    }
    
    func testNumberOfRowssCount() {
        XCTAssertNotNil(mobileDataListViewModel.consumedDataListInstance.count, "Number of rows can not be nil")
    }
    
    func testYearValueInCellForRowData() {
        for consumedDataIndex in mobileDataListViewModel.consumedDataListInstance {
            XCTAssertNotNil(consumedDataIndex.yearValue, "Year value can not be nil")
        }
    }
    
    func testConsumedDataInCellForRowData() {
        for consumedDataIndex in mobileDataListViewModel.consumedDataListInstance {
            XCTAssertNotNil(consumedDataIndex.fetchMobileUsageData, "Consumed data value can not be nil")
        }
    }
    
    func testQuerterlyDataInCellForRowData() {
        for consumedDataIndex in mobileDataListViewModel.consumedDataListInstance {
            XCTAssertNotNil(consumedDataIndex.querterRecord.first?.quarter, "Querterly value can not be nil")
        }
    }
    
    func testNumberOfRows() {
        let rowsCountFromMockData = self.mobileDataListViewModel.consumedDataListInstance.count
        let numberOfRows = mobileDataListViewModel.fetchNumberOfRows()
        XCTAssertEqual(rowsCountFromMockData, numberOfRows)
    }
    
//    func testDataFromRowIndex() {
//        let firstRecord = mobileDataListViewModel.fetchConsumedDataForRow(selectedIndex: 0)
//        XCTAssertEqual(self.mobileDataListViewModel.consumedDataListInstance.first?.yearValue, firstRecord?.yearValue, "Mismatched data")
//    }
    
    func testShowDetailImage() {
        if  self.mobileDataListViewModel.consumedDataListInstance.count > 0 {
            let showDetailBtn = self.mobileDataListViewModel.consumedDataListInstance[0].showDetailView
            XCTAssertNotNil(showDetailBtn,"Show detail can not be nil")
        }
    }
    
    func testFetchMobileListData() {
        let expectedOutput = expectation(description: "success = true")
        XCTAssertNotEqual(self.mobileDataListViewModel.consumedDataListInstance.count, 0)
        networkService.request(url: "datastore_search", method: .get, parameters: createParamDict(limit: 5), headers: [:], uRLEncoding: .default) { (result: Result<MobileDateResponseModel, APIError>)  in
            switch result {
            case .success(let model):
                XCTAssertNotNil(model, "Consumed data should not be nil")
                XCTAssertGreaterThan(model.result.records.count, 0, "Data record should be greater than 0")
            case .failure(let error) :
                XCTFail(error.localizedDescription)
            }
            expectedOutput.fulfill()
        }
        self.wait(for: [expectedOutput], timeout: 15)
    }
    
    func testResponseParsingError() {
        let expectedOutput = expectation(description: "success = true")
        if let networkServiceInstance = networkService as? TestNetworkManager {
            networkServiceInstance.isParseError = true
        }
        networkService.request(url: "datastore_search", method: .get, parameters: createParamDict(limit: 5), headers: [:], uRLEncoding: .default) { (result: Result<MobileDateResponseModel, APIError>)  in
            switch result {
            case .success(let model):
                XCTAssertNotNil(model, "Consumed data should not be nil")
                XCTAssertGreaterThan(model.result.records.count, 0, "Data record should be greater than 0")
            case .failure(let error) :
                XCTAssertNotNil(error)
            }
            expectedOutput.fulfill()
        }
        self.wait(for: [expectedOutput], timeout: 15)
    }
    
    private func createParamDict(limit : Int) -> [String : Any]{
        let param: [String: Any] = ["resource_id": "a807b7ab-6cad-4aa6-87d0-e283a7353a0f", "limit": limit]
        return param
    }
    
    fileprivate func populateMockResponse() -> MobileDateResponseModel?
    {
        return MockDataService.renderMockJsonData(fileName: "ConsumedMobileDataModel")
    }
}

class TestNetworkManager : NetworkManagerService {
    var isInternetAvailable = true
    var fileName = "ConsumedMobileDataModel"
    var isParseError = false
    
    func request<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: Any]?, headers: HTTPHeaders, uRLEncoding: URLEncoding, completion:@escaping ((Result<T, APIError>)) -> Void)  {
        if !isInternetAvailable {
            var apiError = APIError()
            apiError.internetNotAvailble = true
            XCTAssertTrue(isInternetAvailable, "Active internet connection")
            completion(.failure(apiError))
            return
        }
        
        if !isParseError {
            let mockData = MockDataService.renderMockJsonData(fileName: fileName)
            completion(.success(mockData as! T ))
        } else {
            completion(.failure(APIError.init(parseError: ParseError.init(NSError.init(domain: "Parse error", code: 401, userInfo: nil)), error: nil, data: nil, internetNotAvailble: true)))
        }
    }
    
    func testCheckIfInternetIsActive() -> Bool {
        if !NetworkReachabilityManager()!.isReachable {
            return false
        }
        return true
    }
}
