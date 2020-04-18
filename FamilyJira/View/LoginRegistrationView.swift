//
//  LoginRegistrationView.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class LoginRegistrationView: BaseView {
    let segmentControl: UISegmentedControl = {
        let segmentControlItems = ["Login", "Registration"]
        let segmentControl = UISegmentedControl(items: segmentControlItems)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Username"
        textField.isHidden = true
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Confirm password"
        textField.isSecureTextEntry = true
        textField.isHidden = true
        return textField
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonBlue
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Sign In", for: .normal)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10.0
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    override func setupView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(250)
        }
        
        stackView.addArrangedSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-70)
            make.leading.equalToSuperview().offset(70)
        }
        stackView.setCustomSpacing(30.0, after: segmentControl)
        
        [emailTextField,
         usernameTextField,
         passwordTextField,
         confirmPasswordTextField].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-15)
                make.leading.equalToSuperview().offset(15)
            }
        }
        
        stackView.addArrangedSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.width.equalTo(160)
        }
        
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    func formToggle(isLogin: Bool, saveCredentials: Bool = false) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.usernameTextField.isHidden = isLogin
            self?.confirmPasswordTextField.isHidden = isLogin
        }
        actionButton.setTitle(isLogin ? "Sign In" : "Sign Up", for: .normal)
        if !saveCredentials {
            [emailTextField,
             usernameTextField,
             passwordTextField,
             confirmPasswordTextField].forEach {
                $0.text = ""
                $0.resignFirstResponder()
            }
        }
    }
}

extension LoginRegistrationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
