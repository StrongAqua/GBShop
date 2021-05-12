//
//  Review.swift
//  GBShop
//
//  Created by aprirez on 4/20/21.
//

import Foundation

struct Review: Codable {
    let idComment: Int
    let idUser: Int
    let idProduct: Int
    let text: String
}
