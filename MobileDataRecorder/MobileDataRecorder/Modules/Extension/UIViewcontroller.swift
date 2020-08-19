//
//  UIViewcontroller.swift
//  MobileDataRecorder
//
//  Created by Perennial Systems on 19/08/20.
//  Copyright © 2020 Perennial systems. All rights reserved.
//

import UIKit
import TTGSnackbar
import MBProgressHUD

extension UIViewController {
    
    func showAlertViewWithMessage(alertTitle:String,alertMessage:String,alertBtn:String) {
        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: alertBtn, style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(_ message: String, backgroundColor: UIColor? = nil, duration: TTGSnackbarDuration = .middle) {
        let snackbar = TTGSnackbar(message: message, duration: duration)
        snackbar.animationType = .slideFromTopBackToTop
        if let backgroundColor = backgroundColor {
            snackbar.backgroundColor = backgroundColor
        }
        snackbar.show()
    }
    
    func showLoader(label: String? = nil) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = label
        return hud
    }
}
