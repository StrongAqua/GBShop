//
//  ListReviewResult.swift
//  GBShop
//
//  Created by aprirez on 4/21/21.
//

import Foundation

struct ListReviewResult: Codable {
    let pageNumber: Int
    let listReview: [Review]
}
