//
//  WeatherForecastViewController+TableViewDataSourceDelegate.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation
import UIKit


// MARK:- Tableview Datasource

extension WeatherForecastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyViewModel.dayWiseForcating.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch weeklyViewModel.dayWiseForcating.value[indexPath.row] {
        case .normal(let cellValue):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyTableViewCell") as? WeeklyTableViewCell else {
                return UITableViewCell()
            }
            let forecast = cellValue.forecasts as ForecastModel
            let icon = SharedClass.sharedInstance.getWeatherIcon(name: forecast.description)
            cell.configureCell(day: cellValue.day, icon: icon, temp: forecast.temp)
            return cell
            
        case .error(let message):
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = message
            return cell
            
        case .empty:
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            cell.textLabel?.text = "No data available"
            return cell
        }
    }
    
}

// MARK:- Tableview Delegate

extension WeatherForecastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
}
