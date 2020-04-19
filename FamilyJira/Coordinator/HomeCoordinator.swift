//
//  HomeCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/23/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class HomeCoordinator {
    let navigationController: UINavigationController
    private let loginRegistrationCoordinator: LoginRegistrationCoordinator
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        loginRegistrationCoordinator: LoginRegistrationCoordinator,
        homeViewModel: HomeViewModelProtocol = HomeViewModel()
    ) {
        self.loginRegistrationCoordinator = loginRegistrationCoordinator
        let homeViewController = HomeViewController.instantiate(homeViewModel: homeViewModel)
        navigationController = UINavigationController(rootViewController: homeViewController)
        
        homeViewModel.isUserLoggedIn
            .filter { $0 == false }
            .sink(receiveValue: { _ in
                loginRegistrationCoordinator.start()
            })
            .store(in: &subscriptions)
    }
}
