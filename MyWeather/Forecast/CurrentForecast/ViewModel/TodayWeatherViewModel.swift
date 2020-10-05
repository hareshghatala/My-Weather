//
//  TodayWeatherViewModel.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation

class TodayWeatherViewModel {
    
    let appServerClient: AppServerClient
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)
    let description = Bindable(String.init())
    var minTemp = Bindable(String.init())
    var currentTemp = Bindable(String.init())
    var maxTemp = Bindable(String.init())
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    /// Current/Today's weather of city with lat anad lon
    func getCurrentWeatherData(params: [(String, String)]) {
        self.showLoadingHud.value = true
        appServerClient.getTodayWeather(params: params) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.showLoadingHud.value = false
            switch result {
            case .success(let data):
                if let temp = data.main?.temp {
                    strongSelf.currentTemp.value = String(Int(round(temp-273.15))) + "° Current"
                }
                if let temp_min = data.main?.temp_min {
                    strongSelf.minTemp.value = String(Int(round(temp_min-273.15))) + "°   Min"
                }
                if let temp_max = data.main?.temp_max {
                    strongSelf.maxTemp.value = String(Int(round(temp_max-273.15))) + "°   Max"
                }
                if let description = data.weather?.first?.main {
                    strongSelf.description.value = description
                }
                
            case .failure(let error):
                let okAlert = SingleButtonAlert(
                    title: error?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.",
                    message: "Failed to update information.",
                    action: AlertAction(buttonTitle: "OK", handler: { print("Ok pressed!") })
                )
                strongSelf.onShowError?(okAlert)
            }
        }
        
    }
}
