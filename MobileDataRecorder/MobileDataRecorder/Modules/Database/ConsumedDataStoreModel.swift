//
//  ConsumedDataStoreModel.swift
//  MobileDataConsumed
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ConsumedDataStoreModel : Object {
    @objc private dynamic var structData: Data?
    var model: MobileDateResponseModel? {
        get {
            if let data = structData {
                return try? JSONDecoder().decode(MobileDateResponseModel.self, from: data)
            }
            return nil
        }
        set {
            structData = try? JSONEncoder().encode(newValue)
        }
    }
}
