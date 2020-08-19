//
//  MobileDataFactory.swift
//  MobileDataConsumed
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import Foundation

enum MobileConsumedVMType {
   case getMobileConsumedList
}

class MobileConsumedDataFactory {
    static func createMobileDataViewModel(type: MobileConsumedVMType) -> BaseViewModel? {
        let databaseManager = AppService.MobileDatabaseManager()
        let networkManager = AppService.NetworkManager()
        let mobileDataUsage = MobileDataListViewModel.init(databaseManager: databaseManager, networkManager: networkManager)
        return mobileDataUsage
    }
}
