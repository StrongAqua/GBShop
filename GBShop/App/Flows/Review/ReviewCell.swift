//
//  CatalogTableViewCell.swift
//  GBShop
//
//  Created by aprirez on 5/3/21.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    var commentId: Int?

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textView: UITextView = {
        let text = UITextView()
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16)
        text.textAlignment = .left
        text.translatesAutoresizingMaskIntoConstraints = false
        text.sizeToFit()
        text.isScrollEnabled = false
        text.backgroundColor = UIColor.init(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        text.isEditable = false
        return text
    }()

    let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setStandardView(title: "Approve")
        return button
    }()

    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setStandardView(title: "Delete")
        return button
    }()

    @objc func doApprove() {
        guard let idComment = self.commentId else {return}
        let review = requestFactory.makeReviewRequestFactory()
        review.approveReview(
            idComment: idComment
        ) { response in
            switch response.result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    @objc func doDelete() {
        guard let idComment = self.commentId else {return}
        let review = requestFactory.makeReviewRequestFactory()
        review.removeReview(
            idComment: idComment
        ) { response in
            switch response.result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(userNameLabel)
        self.contentView.addSubview(textView)

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),

            textView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])

        if UserSession.instance.isAdmin() {
            self.contentView.addSubview(approveButton)
            self.contentView.addSubview(deleteButton)

            approveButton.addTarget(self, action: #selector(doApprove), for: .touchUpInside)
            deleteButton.addTarget(self, action: #selector(doDelete), for: .touchUpInside)

            NSLayoutConstraint.activate([
                deleteButton.topAnchor
                    .constraint(equalTo: textView.bottomAnchor, constant: 10),
                deleteButton.trailingAnchor
                    .constraint(equalTo: self.trailingAnchor, constant: -20),
                deleteButton.heightAnchor
                    .constraint(equalToConstant: 30),
                approveButton.topAnchor
                    .constraint(equalTo: textView.bottomAnchor, constant: 10),
                approveButton.trailingAnchor
                    .constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
                approveButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(review: Review?) {
        guard let review = review else {
            self.commentId = 0
            self.userNameLabel.text = "#error"
            self.textView.text = "#error"
            return
        }

        self.commentId = review.idComment
        self.userNameLabel.text =
            review.userName == nil
                ? "User: \(review.idUser)"
                : review.userName
        self.textView.text = review.text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

}
