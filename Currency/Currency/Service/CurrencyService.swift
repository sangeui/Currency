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
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL(endpoint)))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidURL(endpoint)))
            return
        }
        
        let queries = queries.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
        
        urlComponents.queryItems = queries
        
        guard let urlSuccessed = urlComponents.url else {
            completion(.failure(.invalidURL(endpoint)))
            return
        }
    }
}
