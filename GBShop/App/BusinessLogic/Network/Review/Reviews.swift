//
//  Reviews.swift
//  GBShop
//
//  Created by aprirez on 4/20/21.
//

import Foundation
import Alamofire

class Reviews: AbstractRequestFactory {
    var baseUrl: URL
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue

    init(
        baseUrl: URL,
        errorParser: AbstractErrorParser,
        sessionManager: Session,
        queue: DispatchQueue = DispatchQueue.global(qos: .utility)) {
        self.baseUrl = baseUrl
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

extension Reviews: ReviewRequestFactory {
    func addReview(idUser: Int, text: String, completionHandler: @escaping (AFDataResponse<AddReviewResult>) -> Void) {
        let requestModel = AddReview(baseUrl: baseUrl, idUser: idUser, text: text)
        self.request(request: requestModel, completionHandler: completionHandler)
    }

    func approveReview(idComment: Int, completionHandler: @escaping (AFDataResponse<ApproveReviewResult>) -> Void) {
        let requestModel = ApproveReview(baseUrl: baseUrl, idComment: idComment)
        self.request(request: requestModel, completionHandler: completionHandler)
    }

    func removeReview(idComment: Int, completionHandler: @escaping (AFDataResponse<RemoveReviewResult>) -> Void) {
        let requestModel = RemoveReview(baseUrl: baseUrl, idComment: idComment)
        self.request(request: requestModel, completionHandler: completionHandler)
    }

    func getListReview(pageNumber: Int, idProduct: Int, completionHandler: @escaping (AFDataResponse<ListReviewResult>) -> Void) {
        let requestModel = ListReview(baseUrl: baseUrl, idProduct: idProduct, pageNumber: pageNumber)
        self.request(request: requestModel, completionHandler: completionHandler)
    }

}

extension Reviews {
    struct AddReview: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "addReview"
        // let path: String = "addReview.json"

        let idUser: Int
        let text: String

        var parameters: Parameters? {
            return [
                "id_user": idUser,
                "text": text
            ]
        }
    }

    struct ApproveReview: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "approveReview"
        // let path: String = "approveReview.json"

        let idComment: Int
        var parameters: Parameters? {
            return [
                "id_comment": idComment
            ]
        }
    }

    struct RemoveReview: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "removeReview"
        // let path: String = "removeReview.json"

        let idComment: Int
        var parameters: Parameters? {
            return [
                "id_comment": idComment
            ]
        }
    }

    struct ListReview: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "listReview"

        let idProduct: Int
        let pageNumber: Int
        var parameters: Parameters? {
            return [
                "id_product": idProduct,
                "page_number": pageNumber
            ]
        }
    }
}
