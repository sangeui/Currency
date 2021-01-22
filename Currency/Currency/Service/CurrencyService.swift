//
//  CurrencyService.swift
//  Currency
//
//  Created by 서상의 on 2021/01/20.
//

import Foundation

typealias CurrencyCompletion  = (Result<Currency, CurrencyServiceError>) -> Void

class CurrencyService {
    private(set) var session: URLSession
    private let jsonDecoder = JSONDecoder()
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(endpoint: String = "http://apilayer.net/api/live", queries: [String: String], completion: @escaping CurrencyCompletion) {
        
        guard let url = makeQueriedURL(endpoint, queries, completion)
        else { return }
        
        let request = makeURLRequest(url)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                switch statusCode {
                case 400..<600: completion(.failure(.httpStatusCode(statusCode)))
                    return
                default: break
                }
            }
            
            guard let data = data else { return }
            
            guard let currency = self.jsonDecode(Currency.self, from: data)
            else { return }
            
            completion(.success(currency))
        }.resume()
    }
}
// MARK: - JSONDecoder
private extension CurrencyService {
    func jsonDecode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        return try? jsonDecoder.decode(type, from: data)
    }
}
// MARK: - URLRequest
private extension CurrencyService {
    func makeURLRequest(_ url: URL) -> URLRequest {
        let request = URLRequest(url: url)
        
        return request
    }
}
// MARK: - URL
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
