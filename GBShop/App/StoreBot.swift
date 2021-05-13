//
//  StoreBot.swift
//  GBShop
//
//  Created by aprirez on 4/25/21.
//

import Foundation
import Alamofire

class StoreBot {

    enum State {
        case initial

        case registering
        case registered

        case loggingIn
        case loggedIn

        case changingRegistrationRecord
        case registrationRecordChanged

        case gettingCatalogInfo
        case gettingCatalogInfoNextPage
        case gettingCatalogInfoDone

        case gettingProductInfo
        case gettingProductInfoDone

        case addingReview
        case addingReviewDone

        case approvingReview
        case approvingReviewDone

        case removingReview
        case removingReviewDone

        case gettingReviews
        case gettingReviewsNextPage
        case gettingReviewsDone

        case gettingBasket
        case gettingBasketDone

        case addingProduct
        case addingProductDone

        case removingProduct
        case removingProductDone

        case payForOrder
        case payForOrderDone

        case loggingOut
        case loggingOutDone

        case botDone
        case botFail
    }

    var state: State = .initial

    var catalogPage: Int = 1
    var catalogCategory: Int = 1

    var reviewsPage: Int = 1

    let requestFactory = RequestFactory(
        baseUrl: URL(string: "https://vast-tor-76749.herokuapp.com/")!
        // baseUrl: URL(string: "http://127.0.0.1:8080/")!
        // baseUrl: URL(string: "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")!
    )

    func log(_ msg: String) {
        print("[STORE BOT], \(state): " + msg)
    }

    func startBot() {
        log("bot started")
        nextState()
    }

    func setState(_ newState: State) {
        log("switching state to \(newState)")
        state = newState
    }

    func nextState() {
        switch state {

        case .initial: setState(.registering)
        case .registered: setState(.loggingIn)
        case .loggedIn: setState(.changingRegistrationRecord)

        case .registrationRecordChanged: setState(.gettingCatalogInfo)
        case .gettingCatalogInfoNextPage: setState(.gettingCatalogInfo)

        case .gettingCatalogInfoDone: setState(.gettingProductInfo)
        case .gettingProductInfoDone: setState(.addingReview)

        case .addingReviewDone: setState(.approvingReview)
        case .approvingReviewDone: setState(.removingReview)
        case .removingReviewDone: setState(.gettingReviews)

        case .gettingReviewsNextPage: setState(.gettingReviews)
        case .gettingReviewsDone: setState(.gettingBasket)

        case .gettingBasketDone: setState(.addingProduct)
        case .addingProductDone: setState(.removingProduct)
        case .removingProductDone: setState(.payForOrder)
        case .payForOrderDone: setState(.loggingOut)
        case .loggingOutDone: setState(.botDone)

        case .botDone:
            log("STORE BOT FINISHED")
            return

        case .botFail:
            log("FATAL ERROR: STORE BOT FAILED")
            return

        default:
            log("FATAL ERROR: next state - WRONG STATE")
            setState(.botFail)
            nextState()
            return
        }

        doStateAction()
    }

    func doStateAction() {
        switch state {
        case .registering: doRegister()
        case .loggingIn: doLogin()
        case .changingRegistrationRecord: doChangeRegRecord()

        case .gettingCatalogInfo: doGetCatalogPage(pageNumber: catalogPage, idCategory: catalogCategory)
        case .gettingProductInfo: doGetProductInfo(idProduct: 123)

        case .addingReview: doAddReviewForProduct(idUser: 123, text: "Nice!")
        case .approvingReview: doApproveReviewForProduct(idComment: 123)
        case .removingReview: doRemoveReviewForProduct(idComment: 123)
        case .gettingReviews: doGetReviewsForProduct(idProduct: 123, pageNumber: reviewsPage)

        case .gettingBasket: doGetBasketForId(idUser: 123)
        case .addingProduct: doAddProductToBasket(idProduct: 123, quantity: 1)
        case .removingProduct: doRemoveProduct(idProduct: 123, quantity: 1)
        case .payForOrder: doPayForBasket()
        case .loggingOut: doLogout()

        default:
            print("BOT FSM: do state action - FATAL ERROR")
            setState(.botFail)
        }
    }

    func actionSuccess(_ result: Any) {
        log("state action success: \(result)")
        switch state {
        case .registering: setState(.registered)
        case .loggingIn: setState(.loggedIn)
        case .changingRegistrationRecord: setState(.registrationRecordChanged)
        case .gettingCatalogInfo:
            if catalogPage < 5 {
                setState(.gettingCatalogInfoNextPage)
                catalogPage += 1
            } else {
                setState(.gettingCatalogInfoDone)
            }
        case .gettingProductInfo: setState(.gettingProductInfoDone)
        case .addingReview: setState(.addingReviewDone)
        case .approvingReview: setState(.approvingReviewDone)
        case .removingReview: setState(.removingReviewDone)
        case .gettingReviews:
            if reviewsPage < 5 {
                setState(.gettingReviewsNextPage)
                reviewsPage += 1
            } else {
                setState(.gettingReviewsDone)
            }
        case .gettingBasket: setState(.gettingBasketDone)
        case .addingProduct: setState(.addingProductDone)
        case .removingProduct: setState(.removingProductDone)
        case .payForOrder: setState(.payForOrderDone)
        case .loggingOut: setState(.botDone)

        default:
            log("BOT FSM: state action success - WRONG STATE")
            setState(.botFail)
        }
        nextState()
    }

    func actionFailed(_ error: AFError) {
        log("state action failed: \(error.localizedDescription)")
        setState(.botFail)
        nextState()
    }

    func botStandardCompletion<T>(_ response: AFDataResponse<T>) {
        switch response.result {
        case .success(let result):
            self.actionSuccess(result)
        case .failure(let error):
            self.actionFailed(error)
        }
    }

    func doRegister() {
        log("\(#function)")
        let register = requestFactory.makeRegistrationRequestFactory()
        register.register(
            userId: 123,
            userName: "Alla",
            password: "qwerty",
            email: "prirez@bk.ru",
            gender: "female",
            creditCard: "1234 5678 9012 3456",
            bio: "???"
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doLogin() {
        log("\(#function)")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.login(
            userName: "Alla",
            password: "qwerty"
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doChangeRegRecord() {
        log("\(#function)")
        let register = requestFactory.makeRegistrationRequestFactory()
        register.changeRegistrationRecord(
            userId: 123,
            userName: "Alla",
            password: "SuP3RS3cR3t",
            email: "prirez@bk.ru",
            gender: "female",
            creditCard: "1234 5678 9012 3456",
            bio: "???"
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doLogout() {
        log("\(#function)")
        let auth = requestFactory.makeAuthRequestFactory()
        auth.logout(
            userId: 123
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doGetCatalogPage(pageNumber: Int, idCategory: Int) {
        log("\(#function)")
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getCatalog(
            pageNumber: pageNumber,
            idCategory: idCategory
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doGetProductInfo(idProduct: Int) {
        log("\(#function)")
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getProductBy(
            idProduct: idProduct
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doAddReviewForProduct(idUser: Int, text: String) {
        log("\(#function)")
        let review = requestFactory.makeReviewRequestFactory()
        review.addReview(
            idUser: idUser, // this is not required! bug in the lesson materials!!!
            text: text
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doApproveReviewForProduct(idComment: Int) {
        log("\(#function)")
        let review = requestFactory.makeReviewRequestFactory()
        review.approveReview(
            idComment: idComment
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doRemoveReviewForProduct(idComment: Int) {
        log("\(#function)")
        let review = requestFactory.makeReviewRequestFactory()
        review.removeReview(
            idComment: idComment
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doGetReviewsForProduct(idProduct: Int, pageNumber: Int) {
        log("\(#function)")
        let review = requestFactory.makeReviewRequestFactory()
        review.getListReview(
            pageNumber: pageNumber,
            idProduct: idProduct
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doGetBasketForId(idUser: Int) {
        log("\(#function)")
        let basket = requestFactory.makeBasketRequestFactory()
        basket.getBasket(
            idUser: idUser
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doAddProductToBasket(idProduct: Int, quantity: Int) {
        let basket = requestFactory.makeBasketRequestFactory()
        basket.addProductToBasket(
            idProduct: idProduct,
            quantity: quantity
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doRemoveProduct(idProduct: Int, quantity: Int) {
        log("\(#function)")
        let basket = requestFactory.makeBasketRequestFactory()
        basket.removeProductFromBasket(
            idProduct: idProduct,
            quantity: quantity
        ) { [weak self] response in self?.botStandardCompletion(response) }
    }

    func doPayForBasket() {
        log("\(#function)")
        let basket = requestFactory.makeBasketRequestFactory()
        basket.payBasket { [weak self] response in self?.botStandardCompletion(response) }
    }

}
