//
//  GBShopUITests.swift
//  GBShopUITests
//
//  Created by aprirez on 4/7/21.
//

import XCTest

class GBShopUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testLoginScreen() throws {
        let app = XCUIApplication()
        
        setupSnapshot(app)
        
        app.launch()
        
        snapshot("LoginScreen")
        
        let signUpButton = app.buttons["SignUp"]
        XCTAssertTrue(signUpButton.exists)
        XCTAssertTrue(signUpButton.isHittable)

        let userNameTextField = app.textFields["Username"]
        XCTAssertTrue(userNameTextField.exists)
        userNameTextField.tap()
        userNameTextField.typeText("123")
        // check the button is still disabled
        XCTAssertFalse(signUpButton.isEnabled)

        let passwordSecureTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("123")
        // check the button become enabled
        XCTAssertTrue(signUpButton.isEnabled)

        signUpButton.tap()

        let catalogTable = app.tables["CatalogTable"]
        XCTAssertTrue(catalogTable.waitForExistence(timeout: 10))
        
        snapshot("ProductScreen")
    }

    func DISABLED_testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
