//
//  CurrencyAPI.swift
//  Currency
//
//  Created by 서상의 on 2021/01/24.
//

import Foundation

struct CurrencyAPI {
    static let key = "bae9d0e6ce4a4b885835497c7fe8f2f2"
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
