//
//  CurrencyServiceTests.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/20.
//

import XCTest
@testable import Currency

class CurrencyServiceTests: XCTestCase {
    
    let endpoint = "http://apilayer.net/api/live"
    let queries = [
        "access_key": "",
        "currencies": "KRW, PHP, JPY",
        "source": "USD",
        "format": "1"
    ]
    
    func testCurrencyService_whenInitialized_isInjectedSession() {
        let session = MockSession()
        let service = CurrencyService(session: session)
        
        XCTAssertNotNil(service.session)
    }
    
    func testCurrencyService_whenRequested_isSuccess() {
        
//        let expectation = XCTestExpectation()
//
//        let session = MockSession()
//        session.populateData()
//        session.populateResponse()
//
//        let service = CurrencyService(session: session)
//
//        service.request(endpoint: endpoint, queries: queries) {
//            result in
//            switch result {
//            case .success(let currency): return
//            case .failure(let error): return
//            }
//        }
//
//        wait(for: [expectation], timeout: 10)
    }
    
    func testCurrencyService_whenRequested_isCorrectURL() {
        
    }
}
