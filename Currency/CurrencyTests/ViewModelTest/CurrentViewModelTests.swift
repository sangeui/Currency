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
    
    let list = [
        "KRW": "한국(KRW)",
        "JPY": "일본(JPY)",
        "PHP": "필리핀(PHP)"
    ]
    
    var sut: CurrencyViewModel!
    
    override func setUp() {
        sut = CurrencyViewModel()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCurrentViewModel_whenInitialized_isInDefaultSrcDst() {
        XCTAssertEqual(sut.source, source)
        XCTAssertEqual(sut.destination, destination)
    }
    
    func testCurrencyViewModel_whenChangedSource_isSuccessed() {
        sut.changeSource(to: "KRW")
        XCTAssertEqual(sut.source, "KRW")
    }
    
    func testCurrencyViewModel_whenChangedDestination_isSuccessed() {
        sut.changeDestination(to: "JPY")
        XCTAssertEqual(sut.destination, "JPY")
    }
    
    func testCurrencyViewModel_whenSentCurrencyList() {
        let viewModel = CurrencyViewModel()
        
        let targetList = list
        let receivedList = viewModel.list
        
        XCTAssertEqual(targetList, receivedList)
    }
}
