//
//  DatabaseManager.swift
//  MobileDataUsage
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import Realm
import RealmSwift


extension AppService {
    
    class MobileDatabaseManager : NSObject, DatabaseManagerService {
        let databaseInstance = try? Realm()
        
        //Save data in database
        func storeDataInDatabase(record: ConsumedDataStoreModel,completionHandler: ( (Bool) -> Void)) {
            guard let realm = self.databaseInstance else {
                completionHandler(false)
                return
            }
            if let fileURL = self.databaseInstance?.configuration.fileURL {
                debugPrint("Realm Path: \(fileURL.absoluteString)")
            }
            do {
                try realm.safeWrite {
                    realm.add(record)
                }
            } catch {
                completionHandler(false)
            }
            completionHandler(true)
        }
        
        //Delete data in database
        func deleteDataFromDatabase(record : ConsumedDataStoreModel) -> Bool {
            guard let realm = self.databaseInstance else {
                return false
            }
            do {
                try realm.safeWrite {
                    realm.delete(record)
                }
            } catch {
                return false
            }
            return true
        }
        
        //Fetch data in database
        func fetchDataFromDatabase() -> [ConsumedDataStoreModel]? {
            guard let realm = self.databaseInstance else {
                return nil
            }
            var objs: Results<ConsumedDataStoreModel>
            objs = realm.objects(ConsumedDataStoreModel.self)
            if objs.isEmpty == false {
                var mobileDataUsageRecords = [ConsumedDataStoreModel]()
                for consumedDataInstance in objs {
                    mobileDataUsageRecords.append(consumedDataInstance)
                }
                return mobileDataUsageRecords
            } else {
                return nil
            }
        }
        
        //Clear data from database
        func clearCacheData(completionHandler: ( (Bool) -> Void)) {
            let consumeDate = self.fetchDataFromDatabase()
            if let consumeDate = consumeDate {
                let isRecordDelete = self.deleteDataFromDatabase(record: consumeDate.first!)
                completionHandler(isRecordDelete)
            } else {
                completionHandler(true)
            }
        }
    }
}

extension Realm {
    /// Validated the current state and returns the safe block.
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
