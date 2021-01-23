//
//  CurrencyViewModelDelegate.swift
//  Currency
//
//  Created by 서상의 on 2021/01/24.
//

import Foundation

protocol CurrencyViewModelDelegate: class {
    
    /// Receiver에게 수취 국가가 변경되었음을 알린다
    /// - Parameters:
    ///   - destination: 변경된 수취 국가의 통화 코드
    ///   - description: 변경된 수취 국가의 통화 코드가 포함된 표현
    func currencyViewModel(didChangeDestination destination: String, description: String)
    
    /// Receiver에게 이용 가능한 수취 국가의 목록이 변경되었음을 알린다
    ///
    /// ```
    ///  list["time"] // 2020-01-01 00:00
    ///  list["description"] // 1,130.05 KRW / USD
    /// ```
    ///
    /// - Parameter list: 이용 가능한 수취 국가 목록
    func currencyViewModel(didChangeCurrencyList list: [String:String])
    
    /// Receiver에게 API 호출이 성공하여, 그 결과를 이용할 수 있음을 알린다
    /// - Parameter currency: 환율 정보를 가지고 있는 딕셔너리
    func currencyViewModel(didReceiveCurrency currency: [String:String])
    
    /// Receiver에게 API 호출이 실패했음을 알린다
    /// - Parameter error: 표현 가능한 오류 문자열
    func currencyViewModel(didReceiveError error: String)
    
    /// Receiver에게 환율을 계산하여 그 결과를 이용할 수 있음을 알린다
    /// - Parameters:
    ///   - result: 표현 가능한 형태로 변환된 문자열
    ///   - isSuccessed: 계산 완료 여부를 나타내는 부울 값
    func currencyViewModel(didCalculate result: String, isSuccessed: Bool)
}
