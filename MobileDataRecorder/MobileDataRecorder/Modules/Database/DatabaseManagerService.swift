//
//  DatabaseManagerService.swift
//  MobileDataConsumed
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import Foundation

protocol DatabaseManagerService : class  {
    func storeDataInDatabase(record:ConsumedDataStoreModel,completionHandler:((Bool) -> Void))
    func fetchDataFromDatabase() -> [ConsumedDataStoreModel]?
    func deleteDataFromDatabase(record:ConsumedDataStoreModel) -> Bool
}
