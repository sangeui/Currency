//
//  CurrencyService.swift
//  Currency
//
//  Created by 서상의 on 2021/01/20.
//

import Foundation

typealias CurrencyCompletion  = (Result<Currency, CurrencyServiceError>) -> Void

class CurrencyService {
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(endpoint: String, queries: [String: String], completion: @escaping CurrencyCompletion) {
        
    }
}
