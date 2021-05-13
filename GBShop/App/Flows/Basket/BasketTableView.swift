//
//  BasketTableView.swift
//  GBShop
//
//  Created by aprirez on 5/11/21.
//

import UIKit

class BasketTableView: UITableView {
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var basketItems: [BasketItem] = [] {
        didSet {
            reloadData()
        }
    }
    
    weak var basketActionsDelegate: BasketActionsDelegate?
    
    func setup() {
        self.dataSource = self
        self.delegate = self
        register(BasketTableViewCell.self, forCellReuseIdentifier: "BasketCell")
        rowHeight = 100
    }
}

extension BasketTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "BasketCell", for: indexPath) as? BasketTableViewCell else {
            return UITableViewCell()
        }
        
        let basketItem = basketItems[indexPath.row]
        cell.delegate = basketActionsDelegate
        cell.basketItem = basketItem
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
