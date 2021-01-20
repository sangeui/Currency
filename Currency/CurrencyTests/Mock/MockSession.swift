//
//  MockSession.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/20.
//

import Foundation

class MockSession: URLSession {
    private var data: Data?
    private var error: Error?
    private var response: HTTPURLResponse?
    
    init(data: Data? = nil, error: Error? = nil, response: HTTPURLResponse? = nil) {
        self.data = data
        self.error = error
        self.response = response
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockDataTask { completionHandler(self.data, self.response, self.error) }
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockDataTask { completionHandler(self.data, self.response, self.error) }
    }
}

class MockDataTask: URLSessionDataTask {
    private let completion: () -> Void
    
    init(completion: @escaping() -> Void) {
        self.completion = completion
    }
    
    override func resume() {
        completion()
    }
}
