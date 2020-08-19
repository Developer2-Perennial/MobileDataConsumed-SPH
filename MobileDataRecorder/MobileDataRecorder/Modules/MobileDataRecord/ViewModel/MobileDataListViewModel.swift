//
//  MobileDataListViewModel.swift
//  MobileDataRecorder
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import UIKit

protocol BaseViewModel : AnyObject {
    func viewModelInitialSetup()
}

protocol MobileDataListDelegate : AnyObject {
    func successOnLoadDate()
    func showErrorOnLoadingDate(errorString:String)
    func reloadTableView()
}

class MobileDataListViewModel: BaseViewModel {
    struct MobileDataConstant {
        let resourceID = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        let dataStoreSearch = "datastore_search"
        let screenTitle = "Mobile Data Usage"
        let mobileDataHeaderTitle = "MobileDataHeaderView"
        let mobileDataTableViewTitle = "MobileDataTableViewCell"
        let mobileDataTitle = "Mobile Data"
        let processingLablTitle = "Processing.."
        let okButtonTitle = "OK"
        let noInternetConnection = "No internet connection"
        let noDataAvailableString = "No data available to display"
        let tableViewCellHeight = 60.0
    }
    
    weak var delegate : MobileDataListDelegate?
    var consumedDataListInstance = [ConsumedDataInstance]()
    let constantString = MobileDataConstant()
    
    func viewModelInitialSetup() {
    }
}

extension MobileDataListViewModel {
    func fetchNumberOfSection() -> Int {
        return consumedDataListInstance.isEmpty ? 0 : 1
    }
    
    func fetchNumberOfRows() -> Int {
        return consumedDataListInstance.count
    }
    
    func fetchConsumedDataForRow(selectedIndex: Int) -> ConsumedDataInstance? {
        return consumedDataListInstance[selectedIndex]
    }
}

