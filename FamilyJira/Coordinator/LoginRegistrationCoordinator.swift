//
//  LoginRegistrationCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

final class LoginRegistrationCoordinator {
    private let tabBarController: UITabBarController
    private let presentNavigationController: UINavigationController
    
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
    }
}
