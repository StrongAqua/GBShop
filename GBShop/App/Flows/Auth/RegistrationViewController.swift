//
//  RegistrationViewController.swift
//  GBShop
//
//  Created by aprirez on 4/28/21.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let firstRegistration: Bool
    let requestFactory = RequestFactory(baseUrl: AppConfig.serverURL)

    init(_ firstRegistration: Bool) {
        self.firstRegistration = firstRegistration
        self.registrationButton.setTitle(
            firstRegistration ? "Register" : "Change",
            for: .normal
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let registrationImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "businessman")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "username"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        textField.addTarget(self, action: #selector(handleRegTextChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "password"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        textField.addTarget(self, action: #selector(handleRegTextChange), for: .editingChanged)
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "email"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        textField.addTarget(self, action: #selector(handleRegTextChange), for: .editingChanged)
        return textField
    }()
    
    let genderTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "gender"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        textField.addTarget(self, action: #selector(handleRegTextChange), for: .editingChanged)
        return textField
    }()
    
    let cardTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "credit card"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        textField.addTarget(self, action: #selector(handleRegTextChange), for: .editingChanged)
        return textField
    }()
    
    let bioTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "bio"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.1)
        textField.addTarget(self, action: #selector(handleRegTextChange), for: .editingChanged)
        return textField
    }()
    
    let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Registration", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(registration), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupViews()
        view.backgroundColor = .white
        self.title = firstRegistration ? "Register" : "Profile"
    }
    
    @objc func registration() {
        validateForm()
    }
    
    func validateForm() {
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else { return }
        guard let userNameText = userNameTextField.text, !userNameText.isEmpty else { return }
        guard let emailText = emailTextField.text, !emailText.isEmpty else { return }
        guard let genderText = genderTextField.text, !genderText.isEmpty else { return }
        guard let cardText = cardTextField.text, !cardText.isEmpty else { return }
        guard let bioText = bioTextField.text, !bioText.isEmpty else { return }
        startRegistration( password: passwordText, userName: userNameText, email: emailText, gender: genderText, creditCard: cardText, bio: bioText )
    }
    
    @objc func startRegistration( password: String, userName: String, email: String, gender: String, creditCard: String, bio: String ) {
        
        let register = requestFactory.makeRegistrationRequestFactory()
        if firstRegistration {
            register.register(
                userId: Int.random(in: 1 ... 10000000),
                userName: userName,
                password: password,
                email: email,
                gender: gender,
                creditCard: creditCard,
                bio: bio
            ) { response in
                switch response.result {
                case .success(let login):
                    print(login)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            register.changeRegistrationRecord(
                userId: Int.random(in: 1 ... 10000000),
                userName: userName,
                password: password,
                email: email,
                gender: gender,
                creditCard: creditCard,
                bio: bio
            ) { response in
                switch response.result {
                case .success(let login):
                    print(login)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    func setupViews() {
        contentView.addSubview(registrationImageView)
        registrationImageView.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor).isActive = true
        registrationImageView.topAnchor
            .constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        registrationImageView.widthAnchor
            .constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        registrationImageView.heightAnchor
            .constraint(equalToConstant: 100).isActive = true
        
        contentView.addSubview(userNameTextField)
        userNameTextField.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor).isActive = true
        userNameTextField.topAnchor
            .constraint(equalTo: registrationImageView.bottomAnchor, constant: 25).isActive = true
        userNameTextField.widthAnchor
            .constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(passwordTextField)
        passwordTextField.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor).isActive = true
        passwordTextField.topAnchor
            .constraint(equalTo: userNameTextField.bottomAnchor, constant: 25).isActive = true
        passwordTextField.widthAnchor
            .constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(emailTextField)
        emailTextField.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor).isActive = true
        emailTextField.topAnchor
            .constraint(equalTo: passwordTextField.bottomAnchor, constant: 25).isActive = true
        emailTextField.widthAnchor
            .constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(genderTextField)
        genderTextField.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor).isActive = true
        genderTextField.topAnchor
            .constraint(equalTo: emailTextField.bottomAnchor, constant: 25).isActive = true
        genderTextField.widthAnchor
            .constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(cardTextField)
        cardTextField.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor).isActive = true
        cardTextField.topAnchor
            .constraint(equalTo: genderTextField.bottomAnchor, constant: 25).isActive = true
        cardTextField.widthAnchor
            .constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(bioTextField)
        bioTextField.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor).isActive = true
        bioTextField.topAnchor
            .constraint(equalTo: cardTextField.bottomAnchor, constant: 25).isActive = true
        bioTextField.widthAnchor
            .constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(registrationButton)
        registrationButton.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor).isActive = true
        registrationButton.topAnchor
            .constraint(equalTo: bioTextField.bottomAnchor, constant: 25).isActive = true
        registrationButton.widthAnchor
            .constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        registrationButton.heightAnchor
            .constraint(equalToConstant: 50).isActive = true
        registrationButton.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor, constant: -400).isActive = true
    }
    
    @objc func handleRegTextChange() {
        let usernameText = userNameTextField.text!
        let passwordText = passwordTextField.text!
        let emailText = emailTextField.text!
        let genderText = genderTextField.text!
        let cardText = cardTextField.text!
        let bioText = bioTextField.text!
        
        let isFormFilled = !usernameText.isEmpty && !passwordText.isEmpty && !emailText.isEmpty && !genderText.isEmpty && !cardText.isEmpty && !bioText.isEmpty
        
        if isFormFilled {
            registrationButton.backgroundColor = UIColor.darkGray
            registrationButton.isEnabled = true
        } else {
            registrationButton.backgroundColor = UIColor.lightGray
            registrationButton.isEnabled = false
        }
    }
    
}
