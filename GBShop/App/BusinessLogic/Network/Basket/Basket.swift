//
//  Basket.swift
//  GBShop
//
//  Created by aprirez on 4/25/21.
//

import Foundation
import Alamofire

class Basket: AbstractRequestFactory {
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

extension Basket: BasketRequestFactory {
    func getBasket(idUser: Int, completionHandler: @escaping (AFDataResponse<GetBasketResult>) -> Void) {
        let requestModel = GetBasket(baseUrl: baseUrl, idUser: idUser)
        self.request(request: requestModel, completionHandler: completionHandler)
    }

    func addProductToBasket(idProduct: Int, quantity: Int, completionHandler: @escaping (AFDataResponse<AddToBasketResult>) -> Void) {
        let requestModel = AddToBasket(baseUrl: baseUrl, idProduct: idProduct, quantity: quantity)
        self.request(request: requestModel, completionHandler: completionHandler)
    }

    func removeProductFromBasket(idProduct: Int, quantity: Int, completionHandler: @escaping (AFDataResponse<RemoveFromBasketResult>) -> Void) {
        let requestModel = RemoveProductFromBasket(baseUrl: baseUrl, idProduct: idProduct, quantity: quantity)
        self.request(request: requestModel, completionHandler: completionHandler)
    }

    func payBasket(completionHandler: @escaping (AFDataResponse<PayBasketResult>) -> Void) {
        let requestModel = PayForBasket(baseUrl: baseUrl)
        self.request(request: requestModel, completionHandler: completionHandler)
    }
}

extension Basket {
    struct GetBasket: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "getBasket"

        let idUser: Int

        var parameters: Parameters? {
            return [
                "id_user": idUser
            ]
        }
    }

    struct AddToBasket: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "addToBasket"

        let idProduct: Int
        let quantity: Int

        var parameters: Parameters? {
            return [
                "id_product": idProduct,
                "quantity": quantity
            ]
        }
    }

    struct RemoveProductFromBasket: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "removeProductFromBasket"

        let idProduct: Int
        let quantity: Int

        var parameters: Parameters? {
            return [
                "id_product": idProduct,
                "quantity": quantity
            ]
        }
    }

    struct PayForBasket: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .post
        let path: String = "payForBasket"

        var parameters: Parameters?
    }
}
