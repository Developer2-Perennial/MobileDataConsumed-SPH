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
    }
    
    // MARK: - Custom methods
    
    func doInitialSetup() {
        self.title = "Mobile Data Usage"
        registerNibs()
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
        return cell!
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

