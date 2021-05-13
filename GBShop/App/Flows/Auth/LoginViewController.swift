//
//  LoginViewController.swift
//  GBShop
//
//  Created by aprirez on 4/28/21.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)
    
    let loginImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "shop")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isAccessibilityElement = true
        textField.accessibilityIdentifier = "Username"
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isAccessibilityElement = true
        textField.accessibilityIdentifier = "Password"
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = "SignUp"
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Registration", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(toRegistration), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .white
        
        setupLoginView()
        setupTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usernameTextField.becomeFirstResponder()
    }
    
    func setupLoginView() {
        view.addSubview(loginImageView)
        loginImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 10).isActive = true
        loginImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loginImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loginImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setupTextFields() {
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField, signUpButton, registrationButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: loginImageView.bottomAnchor, constant: 40).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func handleSignUp() {
        validateForm()
    }
    
    func validateForm() {
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else { return }
        guard let usernameText = usernameTextField.text, !usernameText.isEmpty else { return }
        
        startSigningUp( password: passwordText, userName: usernameText)
    }
    
    func startSigningUp( password: String, userName: String) {
        // TODO: protect this code with state
        let auth = requestFactory.makeAuthRequestFactory()
        auth.login(
            userName: userName,
            password: password
        ) { response in
            switch response.result {
            case .success(let login):
                print(login)
                DispatchQueue.main.async {
                    UserSession.instance.user = login.user
                    self.goToUserAccount()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func handleTextChange() {
        let usernameText = usernameTextField.text!
        let passwordText = passwordTextField.text!
        
        let isFormFilled = !usernameText.isEmpty && !passwordText.isEmpty
        
        if isFormFilled {
            signUpButton.backgroundColor = UIColor.darkGray
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.lightGray
            signUpButton.isEnabled = false
        }
    }
    
    @objc func toRegistration() {
        let registrationViewController = RegistrationViewController(true)
        self.navigationController?.pushViewController( registrationViewController, animated: true)
    }
    
    func goToUserAccount() {
        let appNavigation = UINavigationController()
        appNavigation.viewControllers = [UserTabBarController()]
        appNavigation.modalPresentationStyle = .fullScreen
        self.present(appNavigation, animated: false, completion: {})
    }
}
