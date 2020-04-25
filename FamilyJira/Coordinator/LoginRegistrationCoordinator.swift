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

final class LoginRegistrationCoordinator: Coordinator {
    private let tabBarController: UITabBarController
    let navigationController: UINavigationController
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
        self.navigationController = UINavigationController()
    }
    
    func start(animated: Bool = false,
               completion: (() -> Void)? = nil,
               loginRegistrationViewModel: LoginRegistrationViewModelProtocol = LoginRegistrationViewModel()) {
        let viewController = LoginRegistrationViewController.instantiate(loginRegistrationViewModel: loginRegistrationViewModel)
        navigationController.viewControllers = [viewController]
        navigationController.modalPresentationStyle = .fullScreen
        tabBarController.present(navigationController, animated: animated, completion: completion)
        
        loginRegistrationViewModel.presentAuthError
            .sink(receiveValue: presentError(error:))
            .store(in: &subscriptions)
        
        loginRegistrationViewModel.userLoggedIn
            .sink(receiveValue: { [weak self] _ in
                NotificationCenter.default.post(name: .userLoggedIn, object: nil)
                self?.tabBarController.dismiss(animated: true, completion: nil)
            })
            .store(in: &subscriptions)
    }
}
