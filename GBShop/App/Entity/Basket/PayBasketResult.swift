//
//  PayBasketResult.swift
//  GBShop
//
//  Created by aprirez on 4/25/21.
//

import Foundation

struct PayBasketResult: Codable {
    let result: Int
    let userMessage: String?
    let basket: GetBasketResult
}
