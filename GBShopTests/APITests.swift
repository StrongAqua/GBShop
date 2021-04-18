//
//  APITests.swift
//  GBShopTests
//
//  Created by aprirez on 4/13/21.
//

import XCTest
import Alamofire
@testable import GBShop

class APITests: XCTestCase {

    let requestFactory = RequestFactory(
        baseUrl: URL(string: "https://vast-tor-76749.herokuapp.com/")!
        // baseUrl: URL(string: "http://127.0.0.1:8080/")!
        // baseUrl: URL(string: "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")!
    )
    // https://github.com/StrongAqua/online-store-api/blob/badresponses/responses/
    
    func testRegistration() throws {
        let expectation = XCTestExpectation(description: "APITests.testRegistration success")
        let register = requestFactory.makeRegistrationRequestFactory()
        register.register(
            userId: 123,
            userName: "Tester",
            password: "T3ster",
            email: "test@test.ru",
            gender: "tester",
            creditCard: "1234 5678 9012 3456",
            bio: "tester"
        ) { response in
            switch response.result {
            case .success(let result):
                print(result)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testLogin() throws {
        let expectation = XCTestExpectation(description: "APITests.testLogin success")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.login(
            userName: "Tester",
            password: "T3ster"
        ) { response in
            switch response.result {
            case .success(let login):
                print(login)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testChangeRegistration() throws {
        let expectation = XCTestExpectation(description: "APITests.testChangeRegistration success")
        let register = requestFactory.makeRegistrationRequestFactory()
        register.changeRegistrationRecord(
            userId: 123,
            userName: "Tester2",
            password: "SuP3RST3ster",
            email: "tester@test.ru",
            gender: "supertester",
            creditCard: "1234 5678 9012 3456",
            bio: "supertester"
        ) { response in
            switch response.result {
            case .success(let result):
                print(result)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func doTestGetPage(
        totalPages: Int,
        pageNumber: Int,
        idCategory: Int,
        expectation: XCTestExpectation
    ) {
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getCatalog(pageNumber: pageNumber, idCategory: idCategory)
        { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let catalog):
                print(catalog)
                if (pageNumber < totalPages) {
                    self.doTestGetPage(
                        totalPages: totalPages,
                        pageNumber: pageNumber + 1,
                        idCategory: 1,
                        expectation: expectation
                    )
                } else {
                    expectation.fulfill()
                }
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
        }
    }

    func testCatalog() throws {
        let expectation = XCTestExpectation(description: "APITests.testCatalog success")
        doTestGetPage(
            totalPages: 10,
            pageNumber: 1,
            idCategory: 1,
            expectation: expectation
        )
        wait(for: [expectation], timeout: 10.0)
    }

    func testGetProductInfo() throws {
        let expectation =
            XCTestExpectation(description: "APITests.testGetProductInfo success")
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getProductBy(
            idProduct: 1
        ) { response in
            switch response.result {
            case .success(let product):
                print(product)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLogout() throws {
        let expectation =
            XCTestExpectation(description: "APITests.testLogout success")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.logout(
            userId: 1
        ) { response in
            switch response.result {
            case .success(let logout):
                print(logout)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
}
