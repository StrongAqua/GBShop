//
//  BasketTableViewCell.swift
//  GBShop
//
//  Created by aprirez on 5/11/21.
//

import UIKit

protocol BasketActionsDelegate: AnyObject {
    // args reserved for the future use
    func increaseNumber(cell: BasketTableViewCell, number: Int)
    func decreaseNumber(cell: BasketTableViewCell, number: Int)
    func removeItem(cell: BasketTableViewCell)
}

class BasketTableViewCell: UITableViewCell {
    
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var productId: Int = 0

    weak var delegate: BasketActionsDelegate?

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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let decreaseButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "minus.png")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let increaseButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "plus.png")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var productQuantity: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let deleteItemButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "garbage.png")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var basketItem: BasketItem? {
        willSet(item) {
            guard let item = item else {
                self.productNameLabel.text = "#error"
                self.productPriceLabel.text = "#error"
                self.productQuantity.text = "0"
                return
            }
            self.productId = item.idProduct
            self.productNameLabel.text = item.productName
            self.productPriceLabel.text = "\(String(item.price)) руб."
            self.productQuantity.text  = "\(String(item.quantity))"
        }
    }
    
    func setupSubviews() {
        addSubview(productImage)
        addSubview(productNameLabel)
        addSubview(productPriceLabel)
        addSubview(decreaseButton)
        addSubview(productQuantity)
        addSubview(increaseButton)
        addSubview(deleteItemButton)
    }
    
    func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [decreaseButton, productQuantity, increaseButton, deleteItemButton])

        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leadingAnchor
                .constraint(equalTo: productNameLabel.trailingAnchor, constant: 10),
            stackView.trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.heightAnchor
                .constraint(equalToConstant: 60)
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productImage.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 10),
            productImage.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImage.widthAnchor
                .constraint(equalToConstant: 50),
            productImage.heightAnchor
                .constraint(equalToConstant: 50),
            
            productNameLabel.topAnchor
                .constraint(equalTo: contentView.topAnchor, constant: 10),
            productNameLabel.leadingAnchor
                .constraint(equalTo: productImage.trailingAnchor, constant: 10),
            productNameLabel.widthAnchor
                .constraint(equalToConstant: 150),
            productNameLabel.heightAnchor
                .constraint(equalToConstant: 20),
            
            productPriceLabel.topAnchor
                .constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),
            productPriceLabel.leadingAnchor
                .constraint(equalTo: productImage.trailingAnchor, constant: 10),
            productPriceLabel.widthAnchor
                .constraint(equalToConstant: 150),
            productPriceLabel.heightAnchor
                .constraint(equalToConstant: 20)
        ])
    }
    
    func setupButtonsActions() {
        decreaseButton
            .addTarget(self, action: #selector(decrease), for: .touchUpInside)
        increaseButton
            .addTarget(self, action: #selector(increase), for: .touchUpInside)
        deleteItemButton
            .addTarget(self, action: #selector(removeItem), for: .touchUpInside)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
        setupStackView()

        setupButtonsActions()
    }
    
    @objc func decrease() {
        delegate?.decreaseNumber(cell: self, number: changeQuantity(by: -1))
    }
    
    @objc func increase() {
        delegate?.increaseNumber(cell: self, number: changeQuantity(by: 1))
    }
    
    func changeQuantity(by amount: Int) -> Int {
        var newQuantity = Int(productQuantity.text ?? "0") ?? 0
        newQuantity += amount
        if newQuantity < 0 {
            newQuantity = 0
            productQuantity.text = "0"
        } else {
            productQuantity.text = "\(String(newQuantity))"
        }
        return newQuantity
    }
    
    @objc func removeItem() {
        let basket = requestFactory.makeBasketRequestFactory()
        let quantity: Int = Int(productQuantity.text ?? "0") ?? 0
        basket.removeProductFromBasket(
            idProduct: productId,
            quantity: quantity
        ) { [weak self] response in
            guard let self = self else {return}
            switch response.result {
            case .success(let result):
                print(result)
                self.delegate?.removeItem(cell: self)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
