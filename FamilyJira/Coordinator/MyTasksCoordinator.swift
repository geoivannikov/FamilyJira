//
//  MyTasksCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/23/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class MyTasksCoordinator {
    let navigationController: UINavigationController
    private let taskCoordinator: TaskCoordinator
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        myTasksViewModel: MyTasksViewModelProtocol = MyTasksViewModel()
    ) {
        let myTasksViewController = MyTasksViewController.instantiate(myTasksViewModel: myTasksViewModel)
        navigationController = UINavigationController( rootViewController: myTasksViewController)
        taskCoordinator = TaskCoordinator(navigationController: navigationController)
        
        myTasksViewModel.taskSelected
            .sink(receiveValue: { [weak self] _ in
                self?.taskCoordinator.start()
            })
            .store(in: &subscriptions)
    }
}
