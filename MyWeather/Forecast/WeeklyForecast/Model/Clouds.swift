//
//  Clouds.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation

struct Clouds: Codable {
    
    let all: Int?

    enum CodingKeys: String, CodingKey {
        case all = "all"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(Int.self, forKey: .all)
    }

}
