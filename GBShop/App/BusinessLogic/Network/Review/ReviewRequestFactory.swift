//
//  ReviewRequestFactory.swift
//  GBShop
//
//  Created by aprirez on 4/20/21.
//

import Foundation
import Alamofire

protocol ReviewRequestFactory: AbstractRequestFactory {
    func addReview(idUser: Int, text: String, completionHandler: @escaping (AFDataResponse<AddReviewResult>) -> Void)
    func approveReview(idComment: Int, completionHandler: @escaping (AFDataResponse<ApproveReviewResult>) -> Void)
    func removeReview(idComment: Int, completionHandler: @escaping (AFDataResponse<RemoveReviewResult>) -> Void)
    func getListReview(pageNumber: Int, idProduct: Int, completionHandler: @escaping (AFDataResponse<ListReviewResult>) -> Void)
}
