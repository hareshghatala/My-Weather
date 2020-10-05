//
//  Wind.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation

struct Wind: Codable {
    
    let speed: Double?
    let deg: Double?

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
        deg = try values.decodeIfPresent(Double.self, forKey: .deg)
    }

}
