//
//  User.swift
//  GBShop
//
//  Created by aprirez on 4/11/21.
//

import Foundation

struct User: Codable {
    let idUser: Int
    let userLogin: String
    let userName: String
    let userLastname: String
/*
    enum CodingKeys: String, CodingKey {
        case id = "id_user"
        case login = "user_login"
        case name = "user_name"
        case lastname = "user_lastname"
    }
 */
}
