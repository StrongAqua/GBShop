//
//  ReviewsTableView.swift
//  GBShop
//
//  Created by aprirez on 5/8/21.
//

import Foundation
import UIKit

class ReviewsTableView: UITableView {
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var reviewList: ListReviewResult?
    private var isInitialized = false

    var idProduct: Int = -1 {
        willSet(newProductId) {
            setup(productId: newProductId)
        }
    }
    
    private func setup(productId: Int) {
        guard productId >= 0 else {return}
        if !isInitialized {
            isInitialized = true
            self.dataSource = self
            self.delegate = self
            register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
            rowHeight = UserSession.instance.isAdmin() ? 120 : 80
        }
        doGetReviewsForProduct(idProduct: idProduct, pageNumber: 1)
    }
    
    func doGetReviewsForProduct(idProduct: Int, pageNumber: Int) {
        let review = requestFactory.makeReviewRequestFactory()
        review.getListReview(
            pageNumber: pageNumber,
            idProduct: idProduct
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                print(result)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.reviewList = result
                    self.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ReviewsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewList?.listReview.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else {
            return UITableViewCell()
        }

        let review = reviewList?.listReview[indexPath.row]
        cell.setup(review: review)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
