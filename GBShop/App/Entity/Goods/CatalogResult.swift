//
//  CatalogResult.swift
//  GBShop
//
//  Created by aprirez on 4/18/21.
//

import Foundation

struct CatalogResult: Codable {
    let pageNumber: Int
    let products: [Product]
}
