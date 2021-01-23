//
//  CurrencyList.swift
//  Currency
//
//  Created by 서상의 on 2021/01/23.
//

import Foundation

enum CurrencyList: String, CaseIterable {
    case usd, krw, jpy, php
}
extension CurrencyList {
    var code: String {
        return self.rawValue.uppercased()
    }
    
    var description: String {
        switch self {
        case .usd: return "미국 (USD)"
        case .krw: return "한국 (KRW)"
        case .jpy: return "일본 (JPY)"
        case .php: return "필리핀 (PHP)"
        }
    }
}
