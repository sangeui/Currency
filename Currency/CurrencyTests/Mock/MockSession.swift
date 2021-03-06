//
//  MockSession.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/20.
//

import Foundation

enum MockError: Error {
    case any
}

class MockSession: URLSession {
    var data: Data?
    var error: Error?
    var response: HTTPURLResponse?
    
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

extension MockSession {
    func populateData() {
        let path = Bundle(for: type(of: self)).path(forResource: "MockData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        self.data = data
    }
    func populateResponse(statusCode: Int) {
        let urlString = "http://apilayer.net/api/live?access_key=APIKEYcurrencies=KRW,JPY,PHP&source=USD&format=1"
        let url = URL(string: urlString)!
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        
        self.response = response
    }
    func populateError() {
        self.error = MockError.any
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
