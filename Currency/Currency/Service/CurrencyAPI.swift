//
//  CurrencyAPI.swift
//  Currency
//
//  Created by 서상의 on 2021/01/24.
//

import Foundation

struct CurrencyAPI {
    static let key = "YOUR KEY"
    static let endpoint = "http://apilayer.net/api/live"
    
    static func queries(source: String, currencies: [String]) -> [String:String] {
        return [
            "access_key": key,
            "format": "1",
            "source": source,
            "currencies": currencies.joined(separator: ",")
        ]
    }
}
