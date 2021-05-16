//
//  GetBasketResult.swift
//  GBShop
//
//  Created by aprirez on 4/25/21.
//

import Foundation

struct GetBasketResult: Codable {
    let amount: Int
    let countGoods: Int
    let contents: [BasketItem]
}
