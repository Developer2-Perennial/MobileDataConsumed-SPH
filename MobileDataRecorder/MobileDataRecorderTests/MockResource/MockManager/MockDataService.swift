//
//  MockDataService.swift
//  MobileDataUsage
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import UIKit
@testable import MobileDataRecorder

class MockDataService: NSObject {
    class func renderMockJsonData(fileName:String) -> MobileDateResponseModel? {
        if let mockData = getMockDataFromJsonFile(fileName: fileName, type: MobileDateResponseModel.self) {
            return mockData
        } else {
            return nil
        }
    }
    
   class func getMockDataFromJsonFile<T: Decodable>(fileName: String, type: T.Type) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
            }
        }
        return nil
    }
}
