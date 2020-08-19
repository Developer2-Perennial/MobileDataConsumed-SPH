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
    
    var databaseManager: DatabaseManagerService
    var networkManager: NetworkManagerService
    
    init(databaseManager: DatabaseManagerService, networkManager: NetworkManagerService) {
        self.databaseManager = databaseManager
        self.networkManager = networkManager
    }
    
    
    func viewModelInitialSetup() {
        prepareForFetchingMobileDataConsumed()
    }
    
    private func prepareForFetchingMobileDataConsumed() {
        fetchMobileDataUsageListFromServer(paramDict: createParamDict(limit: 100))
    }
    
    private func createParamDict(limit : Int) -> [String : Any]{
        let param: [String: Any] = ["resource_id": constantString.resourceID, "limit": limit]
        return param
    }
    
    func fetchMobileDataUsageListFromServer(paramDict : [String : Any]) {
        fetchCacheDataFromDatabase()
        self.networkManager.request(url: constantString.dataStoreSearch, method: .get, parameters: paramDict, headers: [:], uRLEncoding: .default) { (result: Result<MobileDateResponseModel, APIError>) in
            switch result {
            case .success(let model):
                self.bindDataToViewModel(consumedData: model)
                self.storeDataIntoDatabase(model: model)
                self.delegate?.successOnLoadDate()
            case .failure(let error) :
                if error.internetNotAvailble {
                    self.delegate?.showErrorOnLoadingDate(errorString: self.constantString.noInternetConnection)
                } else {
                    self.delegate?.showErrorOnLoadingDate(errorString: error.localizedDescription)
                }
            }
        }
    }
    
    func bindDataToViewModel(consumedData: MobileDateResponseModel) {
        var consumedDataDict : [String: [[String: String]]] = [ : ]
        for consumeRecord in consumedData.result.records {
            let yearQuarter = consumeRecord.quarter?.components(separatedBy: "-") //2004-Q3
            if let yearQuarterInstance = yearQuarter, yearQuarterInstance.count > 0 {
                var quartersData = consumedDataDict[yearQuarterInstance.first ?? ""] ?? [[String: String]]()
                var quarterDataDict = [String: String]()
                quarterDataDict["quarter"] = yearQuarterInstance.last
                quarterDataDict["volumeOfMobileData"] = consumeRecord.volumeOfMobileData
                quartersData.append(quarterDataDict)
                consumedDataDict[yearQuarterInstance.first ?? "NA"] = quartersData
            }
        }
        sortYearValue(consumedData: consumedDataDict)
    }
    
    private func storeDataIntoDatabase(model:MobileDateResponseModel) {
        let resultDataObj = ConsumedDataStoreModel()
        resultDataObj.model = model
        AppService.MobileDatabaseManager().clearCacheData { (isResult) in
            AppService.MobileDatabaseManager().storeDataInDatabase(record: resultDataObj) { (isResult) in
                print(isResult)
            }
        }
    }
    
    private func fetchCacheDataFromDatabase() {
        let records = AppService.MobileDatabaseManager().fetchDataFromDatabase()
        if let reoordInstance = records, reoordInstance.count > 0, let modelData = reoordInstance.first?.model {
            self.bindDataToViewModel(consumedData: modelData)
            self.delegate?.successOnLoadDate()
        } else {
            debugPrint("No record in database")
        }
    }
    
    private func sortYearValue(consumedData: [String: [[String: String]]]) {
        consumedDataListInstance.removeAll()
        for (name, quarter) in consumedData {
            consumedDataListInstance.append(ConsumedDataInstance(name: name, quarters: quarter))
        }
        consumedDataListInstance.sort { (yearValueOne, yearValuetwo) -> Bool in
            return yearValueOne.yearValue! > yearValuetwo.yearValue!
        }
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

