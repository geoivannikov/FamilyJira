//
//  MyTasksCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/23/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

final class MyTasksCoordinator {
    let navigationController: UINavigationController
    
    init() {
        let myTasksViewController = MyTasksViewController.instantiate()
        navigationController = UINavigationController( rootViewController: myTasksViewController)
    }
}
