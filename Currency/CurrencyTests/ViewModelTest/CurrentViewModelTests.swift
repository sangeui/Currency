//
//  CurrentViewModelTests.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/20.
//

import XCTest
@testable import Currency

class CurrentViewModelTests: XCTestCase {
    let source = "USD"
    let target = ""
    
    func testCurrentViewModel_whenInitialized_isInDefaultSource() {
        let viewModel = CurrencyViewModel()
    }
}
