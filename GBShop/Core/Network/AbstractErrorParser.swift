//
//  AbstractErrorParser.swift
//  GBShop
//
//  Created by aprirez on 4/11/21.
//

import Foundation

protocol AbstractErrorParser {
    func parse(_ result: Error) -> Error
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error?
}
