//
//  BasketViewController.swift
//  GBShop
//
//  Created by aprirez on 4/29/21.
//

import UIKit
import FirebaseAnalytics

class BasketViewController: UIViewController {
    
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var basketGoodsCount = 0 {
        willSet(newGoodsCount) {
            self.countGoodsLabel.text
                = "Всего позиций: \(String(newGoodsCount))."
        }
    }
    var basketPrice = 0 {
        willSet(newBasketPrice) {
            self.priceLabel.text
                = "Всего к оплате: \(String(newBasketPrice)) руб."
        }
    }
    var basketList: [BasketItem] = []

    let basketTableView: BasketTableView = {
        let table = BasketTableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let countGoodsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let payBasketButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pay", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "Basket"

        navigationController?.navigationBar.topItem?.title = "Basket"
        
        setupView()
        basketTableView.setup()
        basketTableView.basketActionsDelegate = self
        doGetBasketForUser()

        payBasketButton.addTarget(self, action: #selector(payBasket), for: .touchUpInside)
    }
    
    func doGetBasketForUser() {
        let basket = requestFactory.makeBasketRequestFactory()
        basket.getBasket(
            idUser: UserSession.instance.user?.idUser ?? 0
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                print(result)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.basketList = result.contents
                    self.basketGoodsCount = result.countGoods
                    self.basketPrice = result.amount
                    self.basketTableView.basketItems = result.contents
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        view.addSubview(basketTableView)
        view.addSubview(countGoodsLabel)
        view.addSubview(priceLabel)
        view.addSubview(payBasketButton)
        
        NSLayoutConstraint.activate([
            basketTableView.topAnchor
                .constraint(equalTo: view.topAnchor, constant: 10),
            basketTableView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 10),
            basketTableView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -10),
            basketTableView.heightAnchor
                .constraint(equalToConstant: 300),
            
            countGoodsLabel.topAnchor
                .constraint(equalTo: basketTableView.bottomAnchor, constant: 10),
            countGoodsLabel.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 10),
            countGoodsLabel.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -10),
            countGoodsLabel.heightAnchor
                .constraint(equalToConstant: 20),
            
            priceLabel.topAnchor
                .constraint(equalTo: countGoodsLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -10),
            priceLabel.heightAnchor
                .constraint(equalToConstant: 20),
            
            payBasketButton.topAnchor
                .constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            payBasketButton.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 10),
            payBasketButton.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -10),
            payBasketButton.heightAnchor
                .constraint(equalToConstant: 40)
        ])
    }
        
    @objc func payBasket() {
        let request = requestFactory.makeBasketRequestFactory()
        request.payBasket { response in
            switch response.result {
            case .success(let result):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    debugPrint("Analytics: Payment")
                    Analytics.logEvent(
                        AnalyticsEventPurchase,
                        parameters: [
                            AnalyticsParameterCurrency: "RUR",
                            AnalyticsParameterValue: self.basketPrice
                        ])
                    self.basketList = result.basket.contents
                    self.basketGoodsCount = result.basket.countGoods
                    self.basketPrice = result.basket.amount
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension BasketViewController: BasketActionsDelegate {
    func increaseNumber(cell: BasketTableViewCell, number: Int) {
        DispatchQueue.main.async {
            // do nothing now
            // should either request server for the new basket data
            // or process basket changes locally
        }
    }
    
    func decreaseNumber(cell: BasketTableViewCell, number: Int) {
        DispatchQueue.main.async {
            // do nothing now
            // should either request server for the new basket data
            // or process basket changes locally
        }
    }
    
    func removeItem(cell: BasketTableViewCell) {
        DispatchQueue.main.async {
            debugPrint("Analytics: AddToBasket, \(cell.productId)")
            Analytics.logEvent(
                AnalyticsEventRemoveFromCart,
                parameters: [
                    AnalyticsParameterItems: [
                        [
                            AnalyticsParameterItemName: "\(cell.productId)",
                            AnalyticsParameterItemCategory: "default"
                        ]
                    ]
                ])
        }
    }
}
