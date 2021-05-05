//
//  CatalogTableViewController.swift
//  GBShop
//
//  Created by aprirez on 5/3/21.
//

import UIKit

class CatalogTableViewController: UITableViewController {
    
    var requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var productList: CatalogResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.white
        self.title = "Catalog"
        
        tableView.delegate = self
        tableView.dataSource = self
            
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: "CatalogCell")
        tableView.rowHeight = 70
        
        doGetCatalog(pageNumber: 23, idCategory: 11)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let productList = self.productList else { return 0 }
        return productList.products.count
    }
    
    func doGetCatalog(pageNumber: Int, idCategory: Int) {
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getCatalog(
            pageNumber: pageNumber,
            idCategory: idCategory
        ) { response in
            switch response.result {
            case .success(let result):
                print(result)
                DispatchQueue.main.async {
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
            return UITableViewCell()
        }
        
        let product = productList?.products[indexPath.row]
        cell.setUp(name: product?.productName ?? "unknown", price: product?.price ?? 0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let productViewController = ProductViewController()
        navigationController?.pushViewController(productViewController, animated: true)
    }

}
