//
//  SettingsCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/23/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class SettingsCoordinator {
    let navigationController: UINavigationController
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        settingsViewModel: SettingsViewModelProtocol = SettingsViewModel()
    ) {
        let settingsViewController = SettingsViewController.instantiate(settingsViewModel: settingsViewModel)
        navigationController = UINavigationController(rootViewController: settingsViewController)
        
        settingsViewModel.editprofileTapped
            .sink(receiveValue: { [weak self] _ in
                let profileCoordinator = ProfileCoordinator(navigationController: self?.navigationController)
                profileCoordinator.start()
            })
            .store(in: &subscriptions)
    }
}
