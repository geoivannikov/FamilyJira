//
//  SearchBoardCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/25/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class SearchBoardCoordinator: Coordinator {
    let navigationController: UINavigationController
    let presentNavigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        presentNavigationController = UINavigationController()
    }

    func start(
        searchBoardViewModel: SearchBoardViewModelProtocol = SearchBoardViewModel()
    ) {
        let viewController = SearchBoardViewController.instantiate(searchBoardViewModel: searchBoardViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
