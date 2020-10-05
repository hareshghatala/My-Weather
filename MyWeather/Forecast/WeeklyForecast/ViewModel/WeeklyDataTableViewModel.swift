//
//  WeeklyDataTableViewModel.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation

class WeeklyDataTableViewModel {
    
    enum WeeklyDataTableViewCellType {
        case normal(cellValue:(day: String, forecasts: ForecastModel))
        case error(message: String)
        case empty
    }
    
    fileprivate let formatter = DateFormatter()
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)
    
    let dayWiseForcating = Bindable([WeeklyDataTableViewCellType]())
    let navTitle: Bindable = Bindable(String.init())
    let appServerClient: AppServerClient
    
    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    func getWeeklyData(params: [(String, String)]) {
        self.showLoadingHud.value = true
        self.appServerClient.getWeeklyDataOfFiveDays(params: params) { [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.showLoadingHud.value = false
            switch result {
            case .success(let data):
                strongSelf.navTitle.value = data.city?.name ?? ""
                if data.list!.count <= 0 {
                    strongSelf.dayWiseForcating.value = [.empty]
                    return
                }
                let cellData = strongSelf.cells(from: data)
                strongSelf.dayWiseForcating.value = cellData.compactMap { .normal(cellValue: $0) }
                
            case .failure(let error):
                strongSelf.dayWiseForcating.value = [.error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")]
            }
        }
    }
    
    private func cells(from weather: WeeklyWeather) -> [(day: String, forecasts: ForecastModel)] {
        guard let forecasts = weather.list else {
            return Array()
        }
        
        func dateTimestampFromDate(date: NSDate) -> String {
            formatter.dateFormat = "YYMMdd HHmm"
            return formatter.string(from: date as Date)
        }
        
        func dayTimestampFromDateTimstamp(timestamp: String) -> String {
            return String(describing: timestamp.split(separator: " ")[0])
        }
        
        let allTimestamps = forecasts.map { obj -> String in
            let date = NSDate(timeIntervalSince1970: obj.dt!)
            return dateTimestampFromDate(date: date)
        }
        
        var uniqueDayTimestamps = allTimestamps
            .map(dayTimestampFromDateTimstamp)
            .uniqueElements
        
        let currentDay = dateTimestampFromDate(date: NSDate()).components(separatedBy: " ").first
        uniqueDayTimestamps.removeAll { $0 == currentDay }
        
        let forecastsForDays = uniqueDayTimestamps.compactMap { day -> [Forecast] in
            return forecasts.filter { forecast in
                let date = NSDate(timeIntervalSince1970: forecast.dt!)
                let forecastTimestamp = dateTimestampFromDate(date: date)
                let dayOfForecast = dayTimestampFromDateTimstamp(timestamp: forecastTimestamp)
                return dayOfForecast == day
            }
        }
        
        let forcastModel = forecastsForDays.compactMap { aryForecasts -> ForecastModel? in
            let forcast = aryForecasts.max(by: { (a, b) -> Bool in
                return Int(round(a.main?.temp ?? 0)) < Int(round(b.main?.temp ?? 0))
            })!
            return forecastModel(from: forcast)
        }
        
        let days = forecasts.map { obj -> String in
            let date = NSDate(timeIntervalSince1970: obj.dt!)
            return date.dayOfWeek(formatter: formatter)
        }
        
        let dayStrings = days
            .uniqueElements.filter { obj in obj != NSDate().dayOfWeek()! }
        
        //Combine those two Items into an Array of tuples
        return Array(zip(dayStrings, forcastModel))
    }
    
    private func forecastModel(from forecast: Forecast) -> ForecastModel {
        if let dt = forecast.dt, let temprature = forecast.main?.temp_max {
            let date = NSDate(timeIntervalSince1970: dt)
            return ForecastModel(
                time: "\(date.formattedTime(formatter: formatter))",
                description: "\(forecast.weather?.first?.main ?? "")",
                temp: "\(Int(round(temprature) - 273.15))°")
            
        }
        return ForecastModel(time: "", description: "", temp: "")
    }
    
}
