//
//  SharedClass.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import UIKit

class SharedClass: NSObject {
    
    static let sharedInstance = SharedClass()
    let loader = ActivityIndicator(title: "")
    var isLocationReceived = false
    
    func showLoader(strTitle: String) {
        DispatchQueue.main.async {
            self.loader.show(animated: true)
        }
    }
    
    func dismissLoader() {
        DispatchQueue.main.async {
            self.loader.dismiss(animated: true)
        }
    }
    
    func getWeatherThemeColor(name: String) -> UIColor {
        switch name {
        case "Clouds":
            return WeatherType.Coludy.color
        case "Rain":
            return WeatherType.Rainy.color
        case "Thunderstorm":
            return WeatherType.Thunderstorm.color
        case "Sunny":
            return WeatherType.Sunny.color
        default:
            return WeatherType.Default.color
        }
    }
    
    func getWeatherIcon(name: String) -> UIImage {
        switch name {
        case "Clouds":
            return WeatherType.Coludy.icon
        case "Rain":
            return WeatherType.Rainy.icon
        case "Thunderstorm":
            return WeatherType.Thunderstorm.icon
        case "Sunny":
            return WeatherType.Sunny.icon
        default:
            return WeatherType.Default.icon
        }
    }

    func getWeatherImage(name: String) -> UIImage {
        switch name {
        case "Clouds":
            return WeatherType.Coludy.image
        case "Rain":
            return WeatherType.Rainy.image
        case "Thunderstorm":
            return WeatherType.Thunderstorm.image
        case "Sunny":
            return WeatherType.Sunny.image
        default:
            return WeatherType.Default.image
        }
    }
    
}

extension Notification.Name {
    static let getWeatherData = Notification.Name("getWeatherData")
}

