//
//  UIButton+StandardView.swift
//  GBShop
//
//  Created by aprirez on 5/8/21.
//

import Foundation
import UIKit

extension UIButton {
    func setStandardView(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor.lightGray
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
