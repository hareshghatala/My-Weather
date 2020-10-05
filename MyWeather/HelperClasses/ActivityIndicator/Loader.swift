//
//  Loader.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import UIKit

protocol Loader {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView: UIView { get }
    var dialogView: UIView { get set }
}

extension Loader where Self: UIView {
    
    func show(animated: Bool) {
        self.backgroundView.alpha = 0
        
        if var topController = UIApplication.shared.windows.first?.rootViewController {
            while let visibleViewController = (topController as? UINavigationController)?.viewControllers.last {
                topController =  visibleViewController
            }
            topController.view.addSubview(self)
        }
        if animated {
            UIView.animate(withDuration: 0.33,
                           animations: { self.backgroundView.alpha = 0.4 })
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: { self.dialogView.center  = self.center },
                           completion: { completed in })
        } else {
            self.backgroundView.alpha = 0.4
            self.dialogView.center  = self.center
        }
    }
    
    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33,
                           animations: { self.backgroundView.alpha = 0 },
                           completion: { completed in })
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 10,
                           options: UIView.AnimationOptions(rawValue: 0),
                           animations: { self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2) },
                           completion: { completed in self.removeFromSuperview() })
        } else {
            self.removeFromSuperview()
        }
    }
    
}
