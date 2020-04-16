//
//  TaskCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/15/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

final class TaskCoordinator {
    let navigationController: UINavigationController
    let presentNavigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.presentNavigationController = UINavigationController()
    }
    
    func start(
        taskViewModel: TaskViewModelProtocol = TaskViewModel()
    ) {
        let viewController = TaskViewController.instantiate(taskViewModel: taskViewModel)
        presentNavigationController.viewControllers = [viewController]
        navigationController.present(presentNavigationController, animated: true, completion: nil)
    }
}
