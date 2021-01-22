//
//  NumberFormatterTests.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/22.
//

import XCTest
@testable import Currency

class NumberFormatterTests: XCTestCase {
    
    let remittance: Double = 100
    let exchangeRate: Double = 1103.70
    
    let target = "110,370.00"
    
    func testNumberFormatter_whenFormatted_isSuccessed() {
        let inAnotherCurrency = remittance * exchangeRate
        let nsNumber = NSNumber(value: inAnotherCurrency)
        let formatter = NumberFormatter.currencyFormatter
        let formatted = formatter.string(from: nsNumber)
        
        XCTAssertNotNil(formatted)
        XCTAssertEqual(formatted!, target)
    }
}
