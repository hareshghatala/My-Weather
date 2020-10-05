//
//  UIViewController+Extension.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import UIKit

protocol SingleButtonDialogPresenter {
    func presentSingleButtonDialog(alert: SingleButtonAlert)
}

extension UIViewController {
    
    func presentSingleButtonDialog(alert: SingleButtonAlert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                style: .default,
                                                handler: { _ in alert.action.handler?() }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    func showInternetAlert() {
        let okAlert = SingleButtonAlert (
            title: "No network connect",
            message: "Could not connect to the network, failed to update information. Please make sure you are connected to the network.",
            action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") }))
        presentSingleButtonDialog(alert: okAlert)
    }
    
    func showLocationAlert() {
        let locationAlert = SingleButtonAlert (
            title: "Could not find location",
            message: "Please enable location service for the app in device settings and try again.",
            action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") }))
        presentSingleButtonDialog(alert: locationAlert)
        
    }
    
}
