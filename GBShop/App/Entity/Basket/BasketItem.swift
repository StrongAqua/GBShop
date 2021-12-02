//
//  BasketItem.swift
//  GBShop
//
//  Created by aprirez on 4/25/21.
//

import Foundation

struct BasketItem: Codable {
    let quantity: Int
    let idProduct: Int
    let productName: String
    let price: Int
}
