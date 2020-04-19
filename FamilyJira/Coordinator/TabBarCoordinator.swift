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
    
    private let homeCoordinator: HomeCoordinator = {
        let coordinator = HomeCoordinator()
        return coordinator
    }()
    
    private let myTasksCoordinator: MyTasksCoordinator = {
        let coordinator = MyTasksCoordinator()
        return coordinator
    }()
    
    private let settingsCoordinator: SettingsCoordinator = {
        let coordinator = SettingsCoordinator()
        return coordinator
    }()
    
    private let firebaseService: FirebaseServiceProtocol
    
    init(navigationController: UINavigationController,
         window: UIWindow?,
         firebaseService: FirebaseServiceProtocol = FirebaseService()) {
        self.window = window
        self.window?.rootViewController = tabBarController
        loginRegistrationCoordinator = LoginRegistrationCoordinator(tabBarController: tabBarController)
        
        let homeViewController = homeCoordinator.navigationController
        homeViewController.tabBarItem = UITabBarItem(.home)
        let myTasksViewController = myTasksCoordinator.navigationController
        myTasksViewController.tabBarItem = UITabBarItem(.myTasks)
        let settingsViewController = settingsCoordinator.navigationController
        settingsViewController.tabBarItem = UITabBarItem(.settings)
        tabBarController.viewControllers = [homeViewController,
                                            myTasksViewController,
                                            settingsViewController]
        self.firebaseService = firebaseService
    }
    
    func start() {
        if !firebaseService.isUserLoggedIn {
            loginRegistrationCoordinator.start()
        }
    }
}

