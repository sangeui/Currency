//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by 서상의 on 2021/01/22.
//

import Foundation

class CurrencyViewModel {
    var source = "USD"
    var destination = "KRW"
    var currencyRate: Double?
    
    var list: [String: String] {
        let list = CurrencyList.allCases
            .filter({ $0.code != source })
            .filter({ $0.code != destination})
            .reduce(into: [String: String]()) {
                $0[$1.code] = $1.description
            }
            
        return list
    }
    
    var service: CurrencyService
    
    weak var delegate: CurrencyViewModelDelegate? {
        didSet {
//            self.requestCurrencyRate()
            delegate?.currencyViewModel(didChangeCurrencyList: list)
        }
    }
    
    let numberFormatter = NumberFormatter.currencyFormatter
    let dateFormatter = DateFormatter.currencyFormatter
    
    init(service: CurrencyService) {
        self.service = service
    }
    
    func changeSource(to target: String) {
        self.source = target
    }
    
    /// 수취 국가를 변경한다
    ///
    /// CurrencyViewDelegate의 currencyViewModel(didChangeDestination:description:)을 호출한다
    /// - Parameter target: 변경할 수취 국가의 코드
    func changeDestination(to target: String) {
        destination = target
        
        let description = CurrencyList(rawValue: target.lowercased())!.description
        
        delegate?.currencyViewModel(didChangeDestination: target, description: description)
        delegate?.currencyViewModel(didChangeCurrencyList: list)
    }
    
    
    /// 전달 받은 `amount` 값으로 환율을 계산한다
    ///
    /// `CurrencyViewDelegate`의 `currencyViewModel(didCalculate:)`을 호출한다
    /// 이때 해당 메소드로는 완성된 문자열 값이 전달된다
    ///
    /// - warning: 가능한 `amount`의 범위는 0에서 10000으로 제한된다
    /// - Parameter amount: 계산하고자 하는 숫자 값
    /// - Returns: 계산된 환율
    @discardableResult
    func calculate(_ amount: Double) -> Double? {
        guard let rate = currencyRate else { return nil }
        
        guard 0...10000 ~= amount else {
            delegate?.currencyViewModel(didCalculate: "송금액이 바르지 않습니다", isSuccessed: false)
            return nil
        }
        
        let result = rate * amount
        
        guard let formatted = numberFormatter.string(from: result)
        else { return nil }
        
        let description = "수취금액은 \(formatted) \(destination) 입니다"
        
        delegate?.currencyViewModel(didCalculate: description, isSuccessed: true)
        
        return result
    }
    
    /// 현재 설정된 송금 및 수취 국가에 대한 환율을 요청한다
    ///
    /// 요청이 성공하면 `CurrencyViewDelegate`의 `currencyViewModel(didReceiveCurrency:)`를 호출하고
    /// 실패하면 `currencyViewModel(didReceiveError:)`를 호출한다
    func requestCurrencyRate() {
        let queries = [
            "access_key": "bae9d0e6ce4a4b885835497c7fe8f2f2",
            "source": source,
            "currencies": destination,
            "format": "1"
        ]
        service.request(queries: queries) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {

            case .success(let currency):
                
                // 예시: USDKRW
                let rateKey = self.source + self.destination
                
                guard let rate = currency.destinations[rateKey],
                      let formattedRate = self.numberFormatter.string(from: rate)
                else { self.delegate?.currencyViewModel(didReceiveError: "ERROR"); return }
                
                self.currencyRate = rate
                                
                let description = "\(formattedRate) \(self.destination) / \(self.source)"
                
                let time = self.dateFormatter.string(from: currency.timestamp)
                
                let result = [
                    "description": description,
                    "time": time
                ]
                
                self.delegate?.currencyViewModel(didReceiveCurrency: result)

            case .failure(_):
                self.delegate?.currencyViewModel(didReceiveError: "ERROR")
            }
        }
    }
}
