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
    let destination = "KRW"
    
    func testCurrentViewModel_whenInitialized_isInDefaultSrcDst() {
        let viewModel = CurrencyViewModel()
        
        XCTAssertEqual(viewModel.source, source)
        XCTAssertEqual(viewModel.destination, destination)
    }
    
    func testCurrencyViewModel_whenChangedSource_isSuccessed() {
        let viewModel = CurrencyViewModel()
        
        viewModel.changeSource(to: "KRW")
        
        XCTAssertEqual(viewModel.source, "KRW")
    }
    
    func testCurrencyViewModel_whenChangedDestination_isSuccessed() {
        let viewModel = CurrencyViewModel()
        
        viewModel.changeDestination(to: "KRW")
        
        XCTAssertEqual(viewModel.destination, "KRW")
    }
}
