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
