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
    
    func testCurrencyViewModel_whenRequestedCurrencyRate_isSuccessed() {
        
        let expectation = XCTestExpectation()
        
        session.populateData()
        
        sut.currencyRate { (success: [String:String]?, error: String?) in
            
            guard let success = success else { return }
            
            guard let description = success["description"] else { return }
            
            guard let time = success["time"] else { return }
            
            print(description)
            print(time)
            
            expectation.fulfill()
            
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
