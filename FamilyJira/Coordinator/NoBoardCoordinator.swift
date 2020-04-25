//
//  NoBoardCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/25/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class NoBoardCoordinator: Coordinator {
    let navigationController: UINavigationController
    let presentNavigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        presentNavigationController = UINavigationController()
    }
    
    func start(
        noBoardViewModel: NoBoardViewModelProtocol = NoBoardViewModel()
    ) {
        let viewController = NoBoardViewController.instantiate(noBoardViewModel: noBoardViewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
