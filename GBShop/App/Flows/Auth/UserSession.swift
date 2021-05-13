//
//  UserSession.swift
//  GBShop
//
//  Created by aprirez on 5/8/21.
//

import Foundation

class UserSession {
    
    public static let instance = UserSession()
    private init() {
        // dummy
    }
    
    var user: User?
    
    func isAdmin() -> Bool {
        return true // stub
    }
}
