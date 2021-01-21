//
//  CurrencyServiceTests.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/20.
//

import XCTest
@testable import Currency

class CurrencyServiceTests: XCTestCase {
    
    func testCurrencyService_whenInitialized_isInjectedSession() {
        let session = MockSession()
        let service = CurrencyService(session: session)
        
        XCTAssertNotNil(service.session)
    }
    
    func testCurrencyService_whenRequested_isSuccess() {
        
        let expectation = XCTestExpectation()
        
        let session = MockSession()
        session.populateData()
        session.populateResponse()
        
        let service = CurrencyService(session: session)
        
        service.request { (response: URLResponse) in
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
        }
        
        wait(for: <#T##[XCTestExpectation]#>, timeout: <#T##TimeInterval#>)
    }
}
