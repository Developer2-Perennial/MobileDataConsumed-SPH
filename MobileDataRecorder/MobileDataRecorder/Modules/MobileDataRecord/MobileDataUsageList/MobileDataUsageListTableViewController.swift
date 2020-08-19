//
//  MobileDataUsageListTableViewController.swift
//  MobileDataRecorder
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import UIKit
import MBProgressHUD

class MobileDataUsageListTableViewController: UITableViewController {
    
    var loader : MBProgressHUD?
    var viewModel : MobileDataListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialSetup()
        fetchMobileConsumedFromServer()
    }
    
    // MARK: - Custom methods
    
    func doInitialSetup() {
        viewModel = MobileConsumedDataFactory.createMobileDataViewModel(type:.getMobileConsumedList) as? MobileDataListViewModel
        self.title = viewModel.constantString.screenTitle
        viewModel.delegate = self
        registerNibs()
    }
    
    func fetchMobileConsumedFromServer() {
        loader = self.showLoader(label: viewModel.constantString.processingLablTitle)
        self.viewModel.viewModelInitialSetup()
    }
    
    //Register Tableview cell here
    
    func registerNibs() {
        self.tableView.register(UINib(nibName: "MobileDataHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MobileDataHeaderView")
        self.tableView.register(UINib(nibName: "MobileDataTableViewCell", bundle: nil), forCellReuseIdentifier: "MobileDataTableViewCell")
    }
}

// MARK: - Table view data source

extension MobileDataUsageListTableViewController  {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.fetchNumberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchNumberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MobileDataTableViewCell") as? MobileDataTableViewCell
        cell?.showDetailButton.tag = indexPath.row
        cell?.mobileDataTableViewCellDelegate = self
        cell?.populateData(record: viewModel.fetchConsumedDataForRow(selectedIndex: indexPath.row))
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "MobileDataHeaderView") as? MobileDataHeaderView
        headerView?.contentView.backgroundColor = .groupTableViewBackground
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return CGFloat(viewModel.constantString.tableViewCellHeight)
      }
}

// MARK: - View model call back methods

extension MobileDataUsageListTableViewController : MobileDataListDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func successOnLoadDate() {
        DispatchQueue.main.async {
            self.reloadTableView()
            self.loader?.hide(animated: true)
        }
    }
    
    func showErrorOnLoadingDate(errorString: String) {
        DispatchQueue.main.async {
            self.showMessage(errorString)
            self.loader?.hide(animated: true)
        }
    }
}

extension MobileDataUsageListTableViewController : MobileDataTableViewCellDelegate {
    func detailButtonClicked(selectedCellIndex: NSInteger) {
        let rec = viewModel.consumedDataListInstance[selectedCellIndex].fetchDescresedConsumedData()
        self.showAlertViewWithMessage(alertTitle: viewModel.constantString.mobileDataTitle, alertMessage:rec.1, alertBtn: viewModel.constantString.okButtonTitle)
    }
}
