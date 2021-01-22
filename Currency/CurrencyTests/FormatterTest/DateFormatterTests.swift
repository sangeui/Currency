//
//  FormatterTests.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/20.
//

import XCTest
@testable import Currency

class DateFormatterTests: XCTestCase {
    var source: TimeInterval = 1611123846
    var target = "2021-01-20 15:24"

    func testDate_whenConverted_isSuccessed() {
        let formatter = DateFormatter.currencyFormatter
        let converted = formatter.string(from: source)
        
        XCTAssertEqual(converted, target)
    }
}
