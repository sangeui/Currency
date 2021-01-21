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
        
        guard let url = makeQueriedURL(endpoint, queries, completion) else { return }
    }
}

private extension CurrencyService {
    func makeQueriedURL(_ urlString: String, _ queries: [String: String], _ completion: @escaping CurrencyCompletion) -> URL? {
        guard let url = url(urlString, completion) else { return nil }
        
        guard var urlComponents = urlComponents(url, completion) else { return nil }
        
        urlComponents.queryItems = queryItems(queries)
        
        guard let urlQueried = urlComponents.url else {
            completion(.failure(.invalidURL(urlString)))
            return nil
        }
        
        return urlQueried
    }
    func url(_ string: String, _ completion: @escaping CurrencyCompletion) -> URL? {
        guard let url = URL(string: string) else {
            completion(.failure(.invalidURL(string)))
            return nil
        }
        
        return url
    }
    
    func urlComponents(_ url: URL, _ completion: @escaping CurrencyCompletion) -> URLComponents? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidURL(url.absoluteString)))
            return nil
        }
        
        return components
    }
    
    func queryItems(_ queries: [String: String]) -> [URLQueryItem] {
        return queries.compactMap({ URLQueryItem(name: $0.key, value: $0.value) })
    }
}
