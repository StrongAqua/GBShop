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
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "noImage")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let productDescription: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16)
        text.textAlignment = .left
        text.backgroundColor = UIColor.init(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        return text
    }()
    
    let addToBasketButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to basket", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
        return button
    }()
    
    let addReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add my review", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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

    // swiftlint:disable function_body_length
    func setupProductView() {
        view.addSubview(productView)
        productView.translatesAutoresizingMaskIntoConstraints = false

        productView.addSubview(productImageView)
        productView.addSubview(productDescription)
        productView.addSubview(addToBasketButton)

        let productInfo = UIView()
        productInfo.translatesAutoresizingMaskIntoConstraints = false
        productView.addSubview(productInfo)
        productInfo.addSubview(productNameLabel)
        productInfo.addSubview(productPriceLabel)

        NSLayoutConstraint.activate([
            productView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productView.leftAnchor
                .constraint(equalTo: view.leftAnchor),
            productView.rightAnchor
                .constraint(equalTo: view.rightAnchor),
            productView.heightAnchor
                .constraint(equalToConstant: 300),

            productImageView.topAnchor
                .constraint(equalTo: productView.topAnchor, constant: 10),
            productImageView.leadingAnchor
                .constraint(equalTo: productView.leadingAnchor, constant: 10),
            productImageView.widthAnchor
                .constraint(equalToConstant: 100),
            productImageView.heightAnchor
                .constraint(equalToConstant: 100),

            productInfo.centerYAnchor
                .constraint(equalTo: productImageView.centerYAnchor),
            productInfo.leadingAnchor
                .constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productInfo.trailingAnchor
                .constraint(equalTo: productView.trailingAnchor, constant: -10),
            productInfo.heightAnchor
                .constraint(equalToConstant: 20 + 20 + 10),
            
            productNameLabel.topAnchor
                .constraint(equalTo: productInfo.topAnchor),
            productNameLabel.leadingAnchor
                .constraint(equalTo: productInfo.leadingAnchor),
            productNameLabel.trailingAnchor
                .constraint(equalTo: productInfo.trailingAnchor),
            productNameLabel.heightAnchor
                .constraint(equalToConstant: 20),
            
            productPriceLabel.topAnchor
                .constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),
            productPriceLabel.leadingAnchor
                .constraint(equalTo: productInfo.leadingAnchor),
            productPriceLabel.trailingAnchor
                .constraint(equalTo: productInfo.trailingAnchor),
            productPriceLabel.heightAnchor
                .constraint(equalToConstant: 20),
            
            productDescription.topAnchor
                .constraint(equalTo: productImageView.bottomAnchor, constant: 1),
            productDescription.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 10),
            productDescription.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -10),
            
            addToBasketButton.bottomAnchor
                .constraint(equalTo: productView.bottomAnchor, constant: -10),
            addToBasketButton.leadingAnchor
                .constraint(equalTo: productView.leadingAnchor, constant: 50),
            addToBasketButton.trailingAnchor
                .constraint(equalTo: productView.trailingAnchor, constant: -50),
            addToBasketButton.heightAnchor
                .constraint(equalToConstant: 30),
            
            productDescription.bottomAnchor
                .constraint(equalTo: addToBasketButton.topAnchor, constant: -10)
        ])
    }
    
    func setUpReview() {
        view.addSubview(addReviewButton)
        view.addSubview(reviewTableView)

        NSLayoutConstraint.activate([
            addReviewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            addReviewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            addReviewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            addReviewButton.heightAnchor.constraint(equalToConstant: 30),

            reviewTableView.topAnchor.constraint(equalTo: productView.bottomAnchor, constant: 10),
            reviewTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            reviewTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            reviewTableView.bottomAnchor.constraint(equalTo: addReviewButton.topAnchor, constant: -10)
        ])
    }
    
    func doGetProductInfo(idProduct: Int) {
        let goods = requestFactory.makeGoodsRequestFactory()
        goods.getProductBy(
            idProduct: idProduct
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
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
            case .success(_):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.addToBasketButton.setTitle("Added", for: .normal)
                    self.addToBasketButton.isEnabled = false
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
