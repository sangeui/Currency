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
    
    func changeSource(to target: String) {
        self.source = target
    }
    
    func changeDestination(to target: String) {
        self.destination = target
    }
}
