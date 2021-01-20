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
}
