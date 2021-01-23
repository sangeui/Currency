//
//  Currency.swift
//  Currency
//
//  Created by 서상의 on 2021/01/21.
//

import Foundation

struct Currency {
    var success: Bool
    var timestamp: Double
    var source: String
    var destinations: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case success,
             timestamp,
             source
        
        case destinations = "quotes"
    }
}

extension Currency: Decodable {}
