//
//  BasketRequestFactory.swift
//  GBShop
//
//  Created by aprirez on 4/25/21.
//

import Foundation
import Alamofire

protocol BasketRequestFactory: AbstractRequestFactory {
    func getBasket(idUser: Int, completionHandler: @escaping (AFDataResponse<GetBasketResult>) -> Void)
    func addProductToBasket(idProduct: Int, quantity: Int, completionHandler: @escaping (AFDataResponse<AddToBasketResult>) -> Void)
    func removeProductFromBasket(idProduct: Int, quantity: Int, completionHandler: @escaping (AFDataResponse<RemoveFromBasketResult>) -> Void)
    func payBasket(completionHandler: @escaping (AFDataResponse<PayBasketResult>) -> Void)
}
