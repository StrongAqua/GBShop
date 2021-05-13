//
//  CatalogTableViewCell.swift
//  GBShop
//
//  Created by aprirez on 5/3/21.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {
    
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var productList: CatalogResult?
    
    let productImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "noImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIView.ContentMode.scaleAspectFit
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)
        
        NSLayoutConstraint.activate([
            
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),
            
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 20),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -140),
            productNameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            productPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productPriceLabel.leadingAnchor.constraint(equalTo: productNameLabel.trailingAnchor, constant: 20),
            productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            productPriceLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(name: String, price: Int) {
        self.productNameLabel.text = name
        self.productPriceLabel.text = "\(String(price)) руб."
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
