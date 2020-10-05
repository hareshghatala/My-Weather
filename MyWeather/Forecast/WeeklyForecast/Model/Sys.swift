//
//  Sys.swift
//  MyWeather
//
//  Created by Haresh on 2020/10/05.
//  Copyright © 2020 Haresh. All rights reserved.
//

import Foundation

struct Sys: Codable {
    
    let pod: String?

    enum CodingKeys: String, CodingKey {
        case pod = "pod"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pod = try values.decodeIfPresent(String.self, forKey: .pod)
    }

}
