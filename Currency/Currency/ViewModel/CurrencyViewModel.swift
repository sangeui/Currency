//
//  CurrencyViewModel.swift
//  Currency
//
//  Created by 서상의 on 2021/01/22.
//

import Foundation

protocol CurrencyViewModelDelegate: class {
    func currencyViewModel(didChangeDestination destination: String, description: String)
    func currencyViewModel(didChangeCurrencyList list: [String:String])
    func currencyViewModel(didReceiveCurrency currency: [String:String])
    func currencyViewModel(didReceiveError error: String)
}

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
            self.requestCurrencyRate()
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
    }
    
    func calculate(_ amount: Double) -> Double? {
        guard let rate = currencyRate else { return nil }
        
        return amount * rate
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

enum CurrencyList: String, CaseIterable {
    case usd, krw, jpy, php
}
extension CurrencyList {
    var code: String {
        return self.rawValue.uppercased()
    }
    
    var description: String {
        switch self {
        case .usd: return "미국 (USD)"
        case .krw: return "한국 (KRW)"
        case .jpy: return "일본 (JPY)"
        case .php: return "필리핀 (PHP)"
        }
    }
}
