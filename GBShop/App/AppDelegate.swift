//
//  AppDelegate.swift
//  GBShop
//
//  Created by aprirez on 4/7/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let requestFactory = RequestFactory(
        baseUrl: URL(string: "https://vast-tor-76749.herokuapp.com/")!
        // baseUrl: URL(string: "http://127.0.0.1:8080/")!
        // baseUrl: URL(string: "https://raw.githubusercontent.com/GeekBrainsTutorial/online-store-api/master/responses/")!
    )

    func doRegister() {
        let register = requestFactory.makeRegistrationRequestFactory()
        register.register(
            userId: 123,
            userName: "Alla",
            password: "qwerty",
            email: "prirez@bk.ru",
            gender: "female",
            creditCard: "1234 5678 9012 3456",
            bio: "???"
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                print(result)
                self.doLogin()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func doLogin() {
        let auth = requestFactory.makeAuthRequestFactory()
        auth.login(
            userName: "Alla",
            password: "qwerty"
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let login):
                print(login)
                self.doChangeRegRecord()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func doChangeRegRecord() {
        let register = requestFactory.makeRegistrationRequestFactory()
        register.changeRegistrationRecord(
            userId: 123,
            userName: "Alla",
            password: "SuP3RS3cR3t",
            email: "prirez@bk.ru",
            gender: "female",
            creditCard: "1234 5678 9012 3456",
            bio: "???"
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                print(result)
                self.getCatalogPage(pageNumber: 1, idCategory: 1)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func doLogout() {
        let auth = requestFactory.makeAuthRequestFactory()
        auth.logout(
            userId: 123
        ) { response in
            switch response.result {
            case .success(let logout):
                print(logout)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func getCatalogPage(pageNumber: Int, idCategory: Int) {
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getCatalog(pageNumber: pageNumber, idCategory: idCategory) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let catalog):
                print(catalog)
                if pageNumber < 2 {
                    self.getCatalogPage(pageNumber: pageNumber + 1, idCategory: idCategory)
                } else {
                    self.getProduct()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func getProduct() {
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getProductBy(
            idProduct: 123
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let product):
                print(product)
                self.addReviewForProduct()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func addReviewForProduct() {
        let review = requestFactory.makeReviewRequestFactory()
        review.addReview(
            idUser: 123,
            text: "This product is nice"
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let review):
                print(review)
                self.approveReviewForProduct()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func approveReviewForProduct() {
        let review = requestFactory.makeReviewRequestFactory()
        review.approveReview(
            idComment: 123
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let review):
                print(review)
                self.removeReviewForProduct()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func removeReviewForProduct() {
        let review = requestFactory.makeReviewRequestFactory()
        review.removeReview(
            idComment: 123
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let review):
                print(review)
                self.getListReviewForProduct()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func getListReviewForProduct() {
        let review = requestFactory.makeReviewRequestFactory()
        review.getListReview(
            pageNumber: 1,
            idProduct: 123
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let review):
                print(review)
                self.doLogout()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        doRegister()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
