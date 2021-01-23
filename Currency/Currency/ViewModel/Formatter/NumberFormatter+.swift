//
//  NumberFormatter+.swift
//  Currency
//
//  Created by 서상의 on 2021/01/22.
//

import Foundation

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        
        formatter.fixFractionDigits(2)
        
        return formatter
    }
    
    func string(from number: Double) -> String? {
        let nsNumber = NSNumber(value: number)
        let formatted = self.string(from: nsNumber)
        
        return formatted
    }
    
    func fixFractionDigits(_ digits: Int) {
        minimumFractionDigits = digits
        maximumFractionDigits = digits
    }
}
