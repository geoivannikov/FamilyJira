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
    private let presentNavigationController: UINavigationController
    private let searchBoardCoordinator: SearchBoardCoordinator

    private var subscriptions = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        presentNavigationController = UINavigationController()
        searchBoardCoordinator = SearchBoardCoordinator(navigationController: navigationController)
    }

    func start(
        noBoardViewModel: NoBoardViewModelProtocol = NoBoardViewModel()
    ) {
        let viewController = NoBoardViewController.instantiate(noBoardViewModel: noBoardViewModel)
        navigationController.pushViewController(viewController, animated: false)

        noBoardViewModel.joinBoardTapped
            .sink(receiveValue: { [weak self] _ in
                self?.searchBoardCoordinator.start()
            })
            .store(in: &subscriptions)

        noBoardViewModel.presentError
            .sink(receiveValue: presentError(error:))
            .store(in: &subscriptions)

        noBoardViewModel.boardCreated
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .store(in: &subscriptions)
    }
}
