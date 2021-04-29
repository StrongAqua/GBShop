//
//  UserTabBarController.swift
//  GBShop
//
//  Created by aprirez on 4/29/21.
//

import UIKit

class UserTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = RegistrationViewController(false)
        let tabOneBarItem = UITabBarItem(title: "Change Data", image: UIImage(named: "paper.png"), selectedImage: UIImage(named: "paper.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        // Create Tab two
        let tabTwo = BasketViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Basket", image: UIImage(named: "basket.png"), selectedImage: UIImage(named: "basket.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        self.viewControllers = [tabOne, tabTwo]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController){
        print("Selected \(viewController.title ?? "no title")")
    }
}
