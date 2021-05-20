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
        
        // functional way:
        self.viewControllers =
            [
                [CatalogTableViewController(), "Catalog", "catalog.png"],
                [BasketViewController(), "Basket", "basket.png"],
                [RegistrationViewController(false), "Change Data", "paper.png"]
            ]
            .map {
                guard let vc = $0[0] as? UIViewController,
                      let name = $0[1] as? String,
                      let image = $0[2] as? String
                else {return UIViewController()}
                vc.tabBarItem = UITabBarItem(
                   title: name,
                   image: UIImage(named: image),
                   selectedImage: UIImage(named: image)
                )
                return vc
            }

/* classic way:
        // Create Tab one
        let tabOne = CatalogTableViewController()
        let tabOneBarItem = UITabBarItem(title: "Catalog", image: UIImage(named: "catalog.png"), selectedImage: UIImage(named: "catalog.png"))
        tabOne.tabBarItem = tabOneBarItem
        
        // Create Tab two
        let tabTwo = BasketViewController()
        let tabTwoBarItem = UITabBarItem(title: "Basket", image: UIImage(named: "basket.png"), selectedImage: UIImage(named: "basket.png"))
        tabTwo.tabBarItem = tabTwoBarItem
        
        // Create Tab three
        let tabThree = RegistrationViewController(false)
        let tabThreeBarItem = UITabBarItem(title: "Change Data", image: UIImage(named: "paper.png"), selectedImage: UIImage(named: "paper.png"))
        tabThree.tabBarItem = tabThreeBarItem
        
        self.viewControllers = [tabOne, tabTwo, tabThree]
 */
        navigationController?.navigationBar.topItem?.title = (self.viewControllers?[0].title ?? "no title")
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        navigationController?.navigationBar.topItem?.title = (viewController.title ?? "no title")
        // print("Selected \(viewController.title ?? "no title")")
    }
}
