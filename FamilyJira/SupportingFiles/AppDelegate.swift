//
//  AppDelegate.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: TabBarCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FamilyJiraDI.start()
        
        let navigationController = UINavigationController()
        window? = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        coordinator = TabBarCoordinator(navigationController: navigationController, window: window)
        return true
    }
}

