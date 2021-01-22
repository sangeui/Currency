//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by 서상의 on 2021/01/22.
//

import Foundation

class CurrencyViewModel {
    var source = "USD"
    var destination = "KRW"
    
    var list: [String:String] {
        let list = CurrencyList.allCases
            .filter({ $0.code != source })
            .reduce(into: [String: String]()) { $0[$1.code] = $1.description }
            
        return list
    }
    
    var service: CurrencyService
    
    init(service: CurrencyService) {
        self.service = service
    }
    
    func changeSource(to target: String) {
        self.source = target
    }
    
    func changeDestination(to target: String) {
        self.destination = target
    }
}

enum CurrencyList: String, CaseIterable {
    case usd, krw, jpy, php
}
extension CurrencyList {
    var code: String {
        return self.rawValue.uppercased()
    }
    
    var description: String {
        switch self {
        case .usd: return "미국(USD)"
        case .krw: return "한국(KRW)"
        case .jpy: return "일본(JPY)"
        case .php: return "필리핀(PHP)"
        }
    }
}
