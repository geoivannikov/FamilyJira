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

class LoginRegistrationViewController: UIViewController {
    private var loginRegistrationViewModel: LoginRegistrationViewModelProtocol!
    
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
        
        loginRegistrationView.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        loginRegistrationView.formToggle(isLogin: sender.selectedSegmentIndex == 0)
    }
    
    @objc func actionButtonTapped(sender : UIButton) {
    }
}
