//
//  WeeklyTableViewCell.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import UIKit

class WeeklyTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    
    func configureCell(day: String, icon: UIImage, temp: String){
        self.lblDay.text = day
        self.imgWeatherIcon.image = icon
        self.lblTemperature.text = temp
    }
    
    var viewModel: WeeklyCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        if let temp = viewModel?.tempStr{
            lblTemperature.text = temp
        }
        if let day = viewModel?.dayStr {
            print(day)
           lblDay.text = day
        }
    }

}
