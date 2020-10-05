//
//  NSMutableAttributedString+Extension.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    @discardableResult func bold(text: String, font: UIFont!) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font ?? .none!]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(text: String, font: UIFont!) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font ?? .none!]
        let normal = NSMutableAttributedString(string: text, attributes: attrs)
        append(normal)
        return self
    }
    
}
