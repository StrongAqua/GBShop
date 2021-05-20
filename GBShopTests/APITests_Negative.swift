//
//  APITests_Negative.swift
//  GBShopTests
//
//  Created by aprirez on 4/13/21.
//

import XCTest
import Alamofire
@testable import GBShop

class APITestsNegative: XCTestCase {

    let requestFactory = RequestFactory(
        baseUrl: URL(string: "https://github.com/StrongAqua/online-store-api/blob/badresponses/responses/")!
    )

    func testLogin() throws {
        let expectation = XCTestExpectation(description: "APITests_Negative.testLogin success")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.login(
            userName: "Tester",
            password: "T3ster"
        ) { response in
            switch response.result {
            case .success(let login):
                print(login)
                XCTFail("Test unexpectedly got a good response")
            case .failure(let error):
                print(error.localizedDescription)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testLogout() throws {
        let expectation =
            XCTestExpectation(description: "APITests_Negative.testLogout success")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.logout(
            userId: 1
        ) { response in
            switch response.result {
            case .success(let logout):
                print(logout)
                XCTFail("Test should not get a good response, but it get")
            case .failure(let error):
                print(error.localizedDescription)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
