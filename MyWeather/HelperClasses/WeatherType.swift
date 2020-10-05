//
//  WeatherType.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import UIKit

enum WeatherType {
    case Sunny
    case Coludy
    case Rainy
    case Thunderstorm
    case Default
}

extension WeatherType {
    
    var color: UIColor {
        get {
            switch self {
            case .Sunny:
                return UIColor.init(red: 71.0/255.0, green: 171.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            case .Coludy:
                return UIColor.init(red: 84.0/255.0, green: 113.0/255.0, blue: 122.0/255.0, alpha: 1.0)
            case .Rainy, .Thunderstorm:
                return UIColor.init(red: 87.0/255.0, green: 87.0/255.0, blue: 93.0/255.0, alpha: 1.0)
            case .Default:
                return UIColor.init(red: 71.0/255.0, green: 171.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            }
        }
    }
    
    var icon: UIImage {
        get {
            switch self {
            case .Sunny:
                return UIImage.init(named: "clear")!
            case .Coludy:
                return UIImage.init(named: "partlysunny")!
            case .Rainy, .Thunderstorm:
                return UIImage.init(named: "rain")!
            case .Default:
                return UIImage.init(named: "clear")!
            }
        }
    }
    
    var image: UIImage {
        get {
            switch self {
            case .Sunny:
                return UIImage.init(named: "forest_sunny")!
            case .Coludy:
                return UIImage.init(named: "forest_cloudy")!
            case .Rainy, .Thunderstorm:
                return UIImage.init(named: "forest_rainy")!
            case .Default:
                return UIImage.init(named: "forest_sunny")!
            }
        }
    }
    
}
