//
//  CurrencyServiceTests.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/20.
//

import XCTest
@testable import Currency

class CurrencyServiceTests: XCTestCase {
    
    var sut: CurrencyService!
    
    let endpoint = "http://apilayer.net/api/live"
    let queries = [
        "access_key": "",
        "currencies": "KRW,PHP,JPY",
        "source": "USD",
        "format": "1"
    ]
    
    override func setUp() {
        prepareCurrencyService()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCurrencyService_whenInitialized_isInjectedSession() {
        XCTAssertNotNil(sut.session)
    }
    
    func testCurrencyService_whenRequested_isCorrectURL() {
        sut.request(endpoint: endpoint, queries: queries) { result in
            switch result {
            case .failure(.invalidURL(_)): XCTAssert(false)
            default: XCTAssert(true)
            }
        }
    }
    
    func testCurrencyService_whenRequested_isSuccess() {
        let expectation = XCTestExpectation()

        let session = MockSession()
        session.populateData()
        session.populateResponse()

        let service = CurrencyService(session: session)

        service.request(endpoint: endpoint, queries: queries) { result in
            switch result {
            case .success(_): expectation.fulfill()
            case .failure(_): XCTAssert(false)
            }
        }

        wait(for: [expectation], timeout: 10)
    }
    
    func testCurrencyService_whenRequestedFailed_isNetworkErrorPassed() {
        let expectation = XCTestExpectation()
        
        let session = MockSession()
        session.populateError()
        
        let service = CurrencyService(session: session)
        
        service.request(endpoint: endpoint, queries: queries) { result in
            switch result {
            case .failure(.networkError(_)): expectation.fulfill()
            default: return
            }
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
private extension CurrencyServiceTests {
    func prepareCurrencyService() {
        let session = MockSession()
        let service = CurrencyService(session: session)
        
        sut = service
    }
}
