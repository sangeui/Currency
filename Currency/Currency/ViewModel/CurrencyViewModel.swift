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
    
    let numberFormatter = NumberFormatter.currencyFormatter
    let dateFormatter = DateFormatter.currencyFormatter
    
    init(service: CurrencyService) {
        self.service = service
    }
    
    func changeSource(to target: String) {
        self.source = target
    }
    
    func changeDestination(to target: String) {
        self.destination = target
    }
    
    func currencyRate(completion: @escaping ([String:String]?, String?) -> Void) {
        let queries = [
            "access_key": "",
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
                
                guard let rate = currency.destinations[rateKey]
                else { print("❌ 수취 국가 환율 오류"); return }

                guard let formattedRate = self.numberFormatter.string(from: rate)
                else { print("❌ 환율 변환 오류"); return }
                                
                let description = "\(formattedRate) \(self.destination) / \(self.source)"
                
                let time = self.dateFormatter.string(from: currency.timestamp)
                
                let result = [
                    "description": description,
                    "time": time
                ]
                
                completion(result, nil)

            case .failure(let error): print(error.localizedDescription)
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
