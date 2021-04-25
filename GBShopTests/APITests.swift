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

    func checkResponse<T>(_ expectation: XCTestExpectation, _ response: AFDataResponse<T>) {
        switch response.result {
        case .success(let result):
            print(result)
            expectation.fulfill()
        case .failure(let error):
            print(error.localizedDescription)
            XCTFail("Test can't get a good response")
        }
    }

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
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func testLogin() throws {
        let expectation = XCTestExpectation(description: "APITests.testLogin success")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.login(
            userName: "Tester",
            password: "T3ster"
        ) { response in self.checkResponse(expectation, response) }
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
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func doTestGetPage(
        totalPages: Int,
        pageNumber: Int,
        idCategory: Int,
        expectation: XCTestExpectation
    ) {
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getCatalog(
            pageNumber: pageNumber,
            idCategory: idCategory
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let catalog):
                print(catalog)
                if pageNumber < totalPages {
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
                XCTFail("Test can't get a good response")
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
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func testAddReview() throws {
        let expectation =
            XCTestExpectation(description: "APITests.testAddReview success")
        let review = requestFactory.makeReviewRequestFactory()
        review.addReview(
            idUser: 666,
            text: "very-very sad"
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func testApproveReview() throws {
        let expectation =
            XCTestExpectation(description: "APITests.testApproveReview success")
        let review = requestFactory.makeReviewRequestFactory()
        review.approveReview(
            idComment: 777
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func testRemoveReview() throws {
        let expectation =
            XCTestExpectation(description: "APITests.testRemoveReview success")
        let review = requestFactory.makeReviewRequestFactory()
        review.removeReview(
            idComment: 777
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func doTestGetPageForReview(
        totalPages: Int,
        pageNumber: Int,
        idProduct: Int,
        expectation: XCTestExpectation
    ) {
        let reviews = requestFactory.makeReviewRequestFactory()
        reviews.getListReview(
            pageNumber: pageNumber,
            idProduct: idProduct
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let catalog):
                print(catalog)
                if pageNumber < totalPages {
                    self.doTestGetPageForReview(
                        totalPages: totalPages,
                        pageNumber: pageNumber + 1,
                        idProduct: 1,
                        expectation: expectation
                    )
                } else {
                    expectation.fulfill()
                }
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail("Test can't get a good response")
            }
        }
    }

    func testGetListReview() throws {
        let expectation = XCTestExpectation(description: "APITests.testGetListReview success")
        doTestGetPageForReview(
            totalPages: 10,
            pageNumber: 1,
            idProduct: 1,
            expectation: expectation
        )
        wait(for: [expectation], timeout: 10.0)
    }

    func testGetBasketForId() {
        let expectation = XCTestExpectation(description: "APITests.testGetBasketForId success")
        let basket = requestFactory.makeBasketRequestFactory()
        basket.getBasket(
            idUser: 123
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func testAddProductToBasket() {
        let expectation = XCTestExpectation(description: "APITests.testAddProductToBasket success")
        let basket = requestFactory.makeBasketRequestFactory()
        basket.addProductToBasket(
            idProduct: 123,
            quantity: 1
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func testemoveProduct() {
        let expectation = XCTestExpectation(description: "APITests.testemoveProduct success")
        let basket = requestFactory.makeBasketRequestFactory()
        basket.removeProductFromBasket(
            idProduct: 123,
            quantity: 1
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func testPayForBasket() {
        let expectation = XCTestExpectation(description: "APITests.doPayForBasket success")
        let basket = requestFactory.makeBasketRequestFactory()
        basket.payBasket { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

    func testLogout() throws {
        let expectation =
            XCTestExpectation(description: "APITests.testLogout success")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.logout(
            userId: 1
        ) { response in self.checkResponse(expectation, response) }
        wait(for: [expectation], timeout: 10.0)
    }

}
