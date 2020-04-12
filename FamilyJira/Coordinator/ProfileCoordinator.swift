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

final class ProfileCoordinator {
    let navigationController: UINavigationController?
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(
        profileViewModel: ProfileViewModelProtocol = ProfileViewModel()
    ) {
        let profileViewController = ProfileViewController.instantiate(profileViewModel: profileViewModel)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
