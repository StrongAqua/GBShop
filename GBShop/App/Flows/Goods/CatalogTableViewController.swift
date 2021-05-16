//
//  CatalogTableViewController.swift
//  GBShop
//
//  Created by aprirez on 5/3/21.
//

import UIKit
import FirebaseAnalytics

class CatalogTableViewController: UITableViewController {
    
    var requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var productList: CatalogResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor.white
        title = "Catalog"
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.isAccessibilityElement = true
        tableView.accessibilityIdentifier = "CatalogTable"

        tableView.register(
            CatalogTableViewCell.self,
            forCellReuseIdentifier: "CatalogCell"
        )
        tableView.rowHeight = 70
        
        doGetCatalog(pageNumber: 23, idCategory: 11)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        debugPrint("Analytics: ScreenView, \(type(of: self)), \(title ?? "")")
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [AnalyticsParameterScreenClass: type(of: self),
                         AnalyticsParameterScreenName: title ?? ""])
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let productList = self.productList else { return 0 }
        return productList.products.count
    }
    
    func doGetCatalog(pageNumber: Int, idCategory: Int) {
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getCatalog(
            pageNumber: pageNumber,
            idCategory: idCategory
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.productList = result
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as? CatalogTableViewCell else {
            debugPrint("ERROR: can't get reusable cell of class CatalogTableViewCell")
            return UITableViewCell()
        }
        
        guard let product = productList?.products[indexPath.row]
        else {
            cell.setUp(name: "#error", price: 0)
            return cell
        }

        cell.setUp(name: product.productName, price: product.price)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let product = productList?.products[indexPath.row]
        else {
            debugPrint("ERROR: can't found item for the row \(indexPath.row)")
            return
        }
        
        let productViewController = ProductViewController()
        productViewController.idProduct = product.idProduct

        navigationController?.pushViewController(productViewController, animated: true)
    }

}
