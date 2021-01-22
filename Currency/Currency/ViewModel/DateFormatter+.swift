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
}
