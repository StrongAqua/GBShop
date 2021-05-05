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
    var storeBot: StoreBot?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootNC = UINavigationController()
        rootNC.viewControllers = [LoginViewController()]
        window?.rootViewController = rootNC
        window?.backgroundColor = .green
        window?.makeKeyAndVisible()

/*
        storeBot = StoreBot()
        DispatchQueue.main.async { [weak self] in
            self?.storeBot?.startBot()
        }
 */

        return true
    }

}
