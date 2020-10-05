//
//  WeeklyCellViewModel.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation

protocol WeeklyCellViewModel {
    
    var tempStr: String{ get }
    var dayStr: String { get }
    
}

extension Forecast: WeeklyCellViewModel {
    
    var tempStr: String {
        return String(format: "%.2f", self.main?.temp ?? "")
    }
    
    var dayStr: String{
        if let dayString = self.weather?.first!.main {
            return dayString
        }
        return ""
    }
    
}
