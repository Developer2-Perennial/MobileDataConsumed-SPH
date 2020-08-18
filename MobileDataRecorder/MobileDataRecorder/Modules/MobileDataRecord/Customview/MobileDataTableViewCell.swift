//
//  MobileDataTableViewCell.swift
//  MobileDataUsage
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import UIKit

protocol MobileDataTableViewCellDelegate : AnyObject {
    func detailButtonClicked(selectedCellIndex:NSInteger)
}

class MobileDataTableViewCell: UITableViewCell {
    
    weak var mobileDataTableViewCellDelegate : MobileDataTableViewCellDelegate?
    @IBOutlet weak var dataUsageLabel: UILabel!
    @IBOutlet weak var yearValueLabel: UILabel!
    @IBOutlet weak var cellHorizontalView: UIStackView!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var showDetailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
