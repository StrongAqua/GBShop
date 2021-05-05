//
//  BasketViewController.swift
//  GBShop
//
//  Created by aprirez on 4/29/21.
//

import UIKit

class BasketViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = "Basket"
        
        navigationController?.navigationBar.topItem?.title = "Basket"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
