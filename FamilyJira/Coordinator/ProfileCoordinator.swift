//
//  ProfileCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class ProfileCoordinator: Coordinator {
    let navigationController: UINavigationController
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else {
            self.navigationController = UINavigationController()
            return
        }
        self.navigationController = navigationController
    }
    
    func start(
        profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    ) {
        let profileViewController = ProfileViewController.instantiate(profileViewModel: profileViewModel)
        navigationController.pushViewController(profileViewController, animated: true)
        
        profileViewModel.presentError
            .sink(receiveValue: presentError(error:))
            .store(in: &subscriptions)
        
        NotificationCenter.default.publisher(for: .userUpdated, object: nil)
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .store(in: &subscriptions)
    }
}
