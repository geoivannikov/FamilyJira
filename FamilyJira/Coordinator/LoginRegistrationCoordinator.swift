//
//  LoginRegistrationCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class LoginRegistrationCoordinator {
    private let tabBarController: UITabBarController
    private let presentNavigationController: UINavigationController
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.presentNavigationController = UINavigationController()
    }
    
    func start() {
        let loginRegistrationViewModel = LoginRegistrationViewModel()
        let viewController = LoginRegistrationViewController.instantiate(loginRegistrationViewModel: loginRegistrationViewModel)
        presentNavigationController.viewControllers = [viewController]
        presentNavigationController.modalPresentationStyle = .fullScreen
        tabBarController.present(presentNavigationController, animated: false, completion: nil)
        
        loginRegistrationViewModel.presentAuthError
            .sink(receiveValue: presentError(error:))
            .store(in: &subscriptions)
        
        loginRegistrationViewModel.userLoggedIn
            .sink(receiveValue: { [weak self] _ in
                self?.tabBarController.dismiss(animated: true, completion: nil)
            })
            .store(in: &subscriptions)
    }
    
    private func presentError(error: BaseError) {
        let alert = UIAlertController.errorAlert(content: error.errorMessage())
        presentNavigationController.present(alert, animated: true)
    }
}
