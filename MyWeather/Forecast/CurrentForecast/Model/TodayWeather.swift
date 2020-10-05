//
//  TodayWeather.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation

struct TodayWeather: Codable {
    
    let weather: [Weather]?
    let main: Main?
    
    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case main = "main"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
    }
    
}
