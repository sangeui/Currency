//
//  CurrencyServiceError.swift
//  Currency
//
//  Created by 서상의 on 2021/01/21.
//

import Foundation

enum CurrencyServiceError: Error {
    case invalidURL(String)
    case invalidData
    case networkError(Error)
    case httpStatusCode(Int)
}
