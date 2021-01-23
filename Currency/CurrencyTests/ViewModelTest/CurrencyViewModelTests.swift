//
//  CurrentViewModelTests.swift
//  CurrencyTests
//
//  Created by 서상의 on 2021/01/20.
//

import XCTest
@testable import Currency

class CurrencyViewModelTests: XCTestCase {
    let source = "USD"
    let destination = "KRW"
    
    let list = [
        "JPY": "일본 (JPY)",
        "PHP": "필리핀 (PHP)"
    ]
    
    var sut: CurrencyViewModel!
    var session: MockSession!
    
    override func setUp() {
        session = MockSession()
        let service = CurrencyService(session: session)
        sut = CurrencyViewModel(service: service)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCurrencyViewModel_whenInitialized_isInjectedService() {
        let session = MockSession()
        let service = CurrencyService(session: session)
        
        let viewModel = CurrencyViewModel(service: service)
        
        XCTAssertTrue(service === viewModel.service)
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
        let targetList = list
        let receivedList = sut.list
        
        XCTAssertEqual(targetList, receivedList)
    }
    
    func testCurrencyViewModel_whenEnteredNumber_isSuccessed() {
        sut.currencyRate = 900.056691
        let target = 90005.67
        
        let result = sut.calculate(100)!.rounded()
        
        XCTAssertEqual(result, target.rounded())
    }
    
    func testCurrencyViewModel_whenEnteredNumber_isFailed() {
        sut.currencyRate = 1
        let greaterThanMaximum = sut.calculate(100001)
        let lessThanMinimum = sut.calculate(-1)
        
        XCTAssertNil(greaterThanMaximum)
        XCTAssertNil(lessThanMinimum)
    }
    
//    func testCurrencyViewModel_whenRequestedCurrencyRate_isSuccessed() {
//
//        let expectation = XCTestExpectation()
//
//        session.populateData()
//
//        sut.currencyRate { success, error in
//
//            guard let success = success else { return }
//
//            guard let _ = success["description"] else { return }
//
//            guard let _ = success["time"] else { return }
//
//            expectation.fulfill()
//
//        }
//
//        wait(for: [expectation], timeout: 10)
//    }
//
//    func testCurrencyViewModel_whenRequestedCurrencyRate_isFailed() {
//        let expectation = XCTestExpectation()
//
//        session.populateError()
//
//        sut.currencyRate(completion: { success, error in
//            if let _ = error {
//                expectation.fulfill()
//            }
//        })
//
//        wait(for: [expectation], timeout: 10)
//    }
}
