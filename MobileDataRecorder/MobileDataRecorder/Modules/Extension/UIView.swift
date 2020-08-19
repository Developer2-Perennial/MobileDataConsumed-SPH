//
//  UIView.swift
//  MobileDataRecorder
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import UIKit

extension UIView {
    func setBorderColor(borderColor:CGColor, borderWidth:CGFloat, cornerRadius:CGFloat) {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
}
