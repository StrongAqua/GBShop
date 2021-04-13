//
//  GoodsRequestFactory.swift
//  GBShop
//
//  Created by aprirez on 4/13/21.
//

import Foundation
import Alamofire

protocol GoodsRequestFactory: AbstractRequestFactory {
    func getCatalog(completionHandler: @escaping (AFDataResponse<[Product]>) -> Void)
    func getProductBy(idProduct: Int, completionHandler: @escaping (AFDataResponse<ProductResult>) -> Void)
}
