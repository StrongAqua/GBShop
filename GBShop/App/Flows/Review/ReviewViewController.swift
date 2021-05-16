//
//  ReviewViewController.swift
//  GBShop
//
//  Created by aprirez on 5/8/21.
//

import UIKit
import FirebaseAnalytics

class ReviewViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        // NOT IMPLEMENTED YET, LET'S DO ANALYTICS EVENT
        debugPrint("Analytics: Review")
        Analytics.logEvent(
            "ReviewPosted",
            parameters: ["Score": "5"])
    }
}
