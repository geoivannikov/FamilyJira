//
//  LoginRegistrationViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Combine
import Toast_Swift

class LoginRegistrationViewController: UIViewController {
    private var loginRegistrationViewModel: LoginRegistrationViewModelProtocol!
    private var subscriptions = Set<AnyCancellable>()
    
    private let loginRegistrationView: LoginRegistrationView = {
        let loginRegistrationView = LoginRegistrationView()
        return loginRegistrationView
    }()
    
    static func instantiate(
        loginRegistrationViewModel: LoginRegistrationViewModelProtocol
    ) -> LoginRegistrationViewController {
        let viewController: LoginRegistrationViewController = LoginRegistrationViewController()
        viewController.loginRegistrationViewModel = loginRegistrationViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinds()
        setUpLayout()
        dismissKeyboardAfterTap()
    }
    
    private func setUpLayout() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .backgroundBlue
        view.addSubview(loginRegistrationView)
        loginRegistrationView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
        
        loginRegistrationView.segmentControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
    }
    
    private func setUpBinds() {
        let signInTapped = PassthroughSubject<Void, Never>()
        let signUpTapped = PassthroughSubject<Void, Never>()
        
        loginRegistrationView.actionButton
            .publisher(for: .touchUpInside)
            .compactMap { [weak self] _ in
                self?.loginRegistrationView
                    .segmentControl.selectedSegmentIndex == 0
            }
            .sink(receiveValue: { [weak self] isSignIn in
                self?.view.makeToastActivity(.center)
                if isSignIn {
                    signInTapped.send()
                } else {
                    signUpTapped.send()
                }
            })
            .store(in: &subscriptions)
        
        
        signInTapped
            .map { [weak self] _ in
                LoginCredentials(email: self?.loginRegistrationView.emailTextField.text,
                                 password: self?.loginRegistrationView.passwordTextField.text)
            }
            .sink(receiveValue: loginRegistrationViewModel.signInTapped(credentials:))
            .store(in: &subscriptions)
        
        signUpTapped
            .map { [weak self] _ in
                RegistrationCredentials(email: self?.loginRegistrationView.emailTextField.text,
                                        username: self?.loginRegistrationView.usernameTextField.text,
                                        password: self?.loginRegistrationView.passwordTextField.text,
                                        confirmPassword: self?.loginRegistrationView.confirmPasswordTextField.text)
            }
            .sink(receiveValue: loginRegistrationViewModel.signUpTapped(credentials:))
            .store(in: &subscriptions)
        
        loginRegistrationViewModel.presentAuthError
            .sink(receiveValue: { [weak self] _ in
                self?.view.hideToastActivity()
            })
            .store(in: &subscriptions)
        
        loginRegistrationViewModel.registrationSucceed
            .sink(receiveValue: { [weak self] _ in
                self?.view.hideToastActivity()
                self?.view.makeToast("Registration completed succesfully", duration: 1.5, position: .bottom)
                self?.loginRegistrationView.segmentControl.selectedSegmentIndex = 0
                self?.loginRegistrationView.formToggle(isLogin: true, saveCredentials: true)
            })
            .store(in: &subscriptions)
    }
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        loginRegistrationView.formToggle(isLogin: sender.selectedSegmentIndex == 0)
    }
}
