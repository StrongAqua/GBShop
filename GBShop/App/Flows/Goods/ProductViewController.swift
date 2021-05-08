//
//  ProductViewController.swift
//  GBShop
//
//  Created by aprirez on 5/4/21.
//

import UIKit

class ProductViewController: UIViewController {
    
    // MARK: Properties
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var productList: CatalogResult?
    var product: ProductResult? {
        willSet(newProduct) {
            self.productNameLabel.text = newProduct?.productName ?? "unknown"
            self.productPriceLabel.text = "\(String(newProduct?.productPrice ?? 0)) руб."
            self.productDescription.text = newProduct?.productDescription ?? ""
        }
    }
    var idProduct = 0
    let productView = UIView()
    let reviewTableView: ReviewsTableView = {
        let table = ReviewsTableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let productImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productDescription: UITextView = {
        let text = UITextView()
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16)
        text.textAlignment = .left
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.init(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        return text
    }()
    
    let addToBasketButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to basket", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
        return button
    }()
    
    let addReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add my review", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(addReview), for: .touchUpInside)
        return button
    }()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        doGetProductInfo(idProduct: idProduct)
        setupProductView()
        setUpReview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.layoutIfNeeded()
        productView.layoutIfNeeded()
        productImageView.layoutIfNeeded()
    }
    
    // MARK: - Methods
    func setupProductView() {
        view.addSubview(productView)
        productView.translatesAutoresizingMaskIntoConstraints = false
        productView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: 0).isActive = true
        productView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                          constant: 0).isActive = true
        productView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                           constant: 0).isActive = true
        productView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        productView.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: productView.topAnchor,
                                              constant: 10).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: productView.leadingAnchor, constant: 10).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        print(productView.frame)
        
        let productInfo = UIView()
        productView.addSubview(productInfo)
        productInfo.translatesAutoresizingMaskIntoConstraints = false
        productInfo.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor).isActive = true
        productInfo.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10).isActive = true
        productInfo.trailingAnchor.constraint(equalTo: productView.trailingAnchor, constant: -10).isActive = true
        productInfo.heightAnchor.constraint(equalToConstant: 20 + 20 + 10).isActive = true
        
        productInfo.addSubview(productNameLabel)
        productNameLabel.topAnchor.constraint(equalTo: productInfo.topAnchor).isActive = true
        productNameLabel.leadingAnchor.constraint(equalTo: productInfo.leadingAnchor).isActive = true
        productNameLabel.trailingAnchor.constraint(equalTo: productInfo.trailingAnchor).isActive = true
        productNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        productInfo.addSubview(productPriceLabel)
        productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10).isActive = true
        productPriceLabel.leadingAnchor.constraint(equalTo: productInfo.leadingAnchor).isActive = true
        productPriceLabel.trailingAnchor.constraint(equalTo: productInfo.trailingAnchor).isActive = true
        productPriceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        productView.addSubview(productDescription)
        productDescription.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 1).isActive = true
        productDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        productDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        productView.addSubview(addToBasketButton)
        addToBasketButton.bottomAnchor.constraint(equalTo: productView.bottomAnchor, constant: -10).isActive = true
        addToBasketButton.leadingAnchor.constraint(equalTo: productView.leadingAnchor, constant: 50).isActive = true
        addToBasketButton.trailingAnchor.constraint(equalTo: productView.trailingAnchor, constant: -50).isActive = true
        addToBasketButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        productDescription.bottomAnchor.constraint(equalTo: addToBasketButton.topAnchor, constant: -10).isActive = true
    }
    
    func setUpReview() {
        view.addSubview(addReviewButton)
        addReviewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        addReviewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        addReviewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        addReviewButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        view.addSubview(reviewTableView)
        reviewTableView.topAnchor.constraint(equalTo: productView.bottomAnchor, constant: 10).isActive = true
        reviewTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        reviewTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        reviewTableView.bottomAnchor.constraint(equalTo: addReviewButton.topAnchor, constant: -10).isActive = true
    }
    
    func doGetProductInfo(idProduct: Int) {
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getProductBy(
            idProduct: idProduct
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                print(result)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.product = result
                    self.reviewTableView.idProduct = idProduct
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func addToBasket() {
        doAddProductToBasket(idProduct: idProduct, quantity: 1)
    }
    
    func doAddProductToBasket(idProduct: Int, quantity: Int) {
        let basket = requestFactory.makeBasketRequestFactory()
        basket.addProductToBasket(
            idProduct: idProduct,
            quantity: quantity
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                print(result)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.addToBasketButton.setTitle("Added", for: .normal)
                }
            case .failure(let error):
                print(error.localizedDescription)
                _ = UIAlertController(title: "Error", message: "Good didn't add to basket", preferredStyle: UIAlertController.Style.alert)
            }
        }
    }
    
    @objc func addReview() {
        let reviewViewController = ReviewViewController()
        self.navigationController?.pushViewController( reviewViewController, animated: true)
    }
        
}
