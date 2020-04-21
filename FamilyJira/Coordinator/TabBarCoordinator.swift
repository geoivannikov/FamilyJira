//
//  TabBarCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit
import Combine
import Firebase

class TabBarCoordinator {
    private var window: UIWindow?

    private var tabBarController: UITabBarController = {
        let mainTabBarController = UITabBarController()
        mainTabBarController.tabBar.itemPositioning = .fill
        mainTabBarController.view.backgroundColor = .white
        return mainTabBarController
    }()
    
    private let loginRegistrationCoordinator: LoginRegistrationCoordinator
    private let homeCoordinator: HomeCoordinator
    private let myTasksCoordinator: MyTasksCoordinator
    private let settingsCoordinator: SettingsCoordinator
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController,
         window: UIWindow?) {
        self.window = window
        self.window?.rootViewController = tabBarController
        loginRegistrationCoordinator = LoginRegistrationCoordinator(tabBarController: tabBarController)
        homeCoordinator = HomeCoordinator(loginRegistrationCoordinator: loginRegistrationCoordinator)
        myTasksCoordinator = MyTasksCoordinator()
        settingsCoordinator = SettingsCoordinator()

        let homeViewController = homeCoordinator.navigationController
        homeViewController.tabBarItem = UITabBarItem(.home)
        let myTasksViewController = myTasksCoordinator.navigationController
        myTasksViewController.tabBarItem = UITabBarItem(.myTasks)
        let settingsViewController = settingsCoordinator.navigationController
        settingsViewController.tabBarItem = UITabBarItem(.settings)
        tabBarController.viewControllers = [homeViewController,
                                            myTasksViewController,
                                            settingsViewController]
        
        NotificationCenter.default.publisher(for: .userLoggedOut, object: nil)
            .sink(receiveValue: { [weak self] _ in
                self?.signOut()
            })
            .store(in: &subscriptions)
    }
    
    private func signOut() {
        loginRegistrationCoordinator.start(animated: true,
                                           completion: { [weak self] in
            self?.tabBarController.selectedIndex = 0
        })
    }
}

