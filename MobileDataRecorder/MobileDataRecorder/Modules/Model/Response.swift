
//
//  MobileDataListViewModel.swift
//  MobileDataConsumed
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import Foundation

// MARK: - MobileDateResponseModel

public struct MobileDateResponseModel : Codable {
    let help: String
    let success: Bool
    var result: MobileDataModel
}

// MARK: - MobileDataModel

public struct MobileDataModel : Codable {
    var resourceID: String
    var fields: [MobileField]
    var records: [DataRecord]
    var links: MobileLinks
    var limit, total: Int
    
    enum CodingKeys: String, CodingKey {
        case resourceID = "resource_id"
        case fields, records
        case links = "_links"
        case limit, total
    }
}

// MARK: - MobileField

public struct MobileField: Codable {
    let type, fieldID: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case fieldID = "id"
    }
}

// MARK: - MobileLinks
public struct MobileLinks: Codable {
    let start, next: String
}

// MARK: - MobileRecord
struct DataRecord : Codable {
    var volumeOfMobileData, quarter: String?
    var recordID: Int?
    
    enum CodingKeys: String, CodingKey {
        case volumeOfMobileData = "volume_of_mobile_data"
        case quarter
        case recordID = "_id"
    }
}

class ConsumedDataInstance: Codable {
    var yearValue: String?
    var querterRecord: [DataRecord] = [DataRecord]()
    var showDetailView = false
    
    init(name: String, quarters: [[String: String]]) {
        self.yearValue = name
        for quarter in quarters {
            let record = DataRecord.init(volumeOfMobileData: quarter["volumeOfMobileData"], quarter: quarter["quarter"], recordID: nil)
            self.querterRecord.append(record)
        }
        self.querterRecord.sort { (r1, r2) -> Bool in
            return r1.quarter! < r2.quarter!
        }
    }
    
    func fetchMobileUsageData() -> String {
        var valumeData = 0.0
        for quarter in querterRecord {
            if let volume = quarter.volumeOfMobileData, let numberData = Double(volume) {
                valumeData += numberData
            }
        }
        return String(format: "%.3f",valumeData)
    }
    
    func fetchDescresedConsumedData() -> (Bool, String) {
        var consumedData = 0.0
        var infoMessage = "Deduction in consuming data in this Querter"
        var isDataConsumedDescreased = false
        for quarter in querterRecord {
            if let volume = quarter.volumeOfMobileData, let numberData = Double(volume) {
                if numberData < consumedData {
                    infoMessage += " (" + quarter.quarter! + ")" + ","
                    isDataConsumedDescreased = true
                }
                consumedData = numberData
            }
        }
        infoMessage.removeLast()
        return (isDataConsumedDescreased, infoMessage)
    }    
}

