//
//  ActivityIndicator.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator: UIView, Loader {
    
    var backgroundView = UIView()
    var dialogView = UIView()
    var strTitle = ""
    
    convenience init(title:String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(title:String) {
        strTitle = title
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.4
        addSubview(backgroundView)
        
        let jeremyGif = UIImage.gifImageWithName(name: "Ripple")
        let imageView = UIImageView(image: jeremyGif)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        imageView.center = backgroundView.center
        imageView.layer.cornerRadius = 20.0
        imageView.startAnimating()
        addSubview(imageView)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        dismiss(animated: true)
    }

}
