//
//  DateFormatter+.swift
//  Currency
//
//  Created by 서상의 on 2021/01/22.
//

import Foundation

extension DateFormatter {
    static var currencyFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter
    }
    
    func string(from timeIntervalSince1970: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        return self.string(from: date)
    }
}
