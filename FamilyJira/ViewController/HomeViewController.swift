//
//  HomeViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit
import Combine
import Toast_Swift

class HomeViewController: UIViewController {
    private var homeViewModel: HomeViewModelProtocol!

    private var subscriptions = Set<AnyCancellable>()

    static func instantiate(homeViewModel: HomeViewModelProtocol) -> HomeViewController {
        let viewController: HomeViewController = HomeViewController()
        viewController.homeViewModel = homeViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpBinds()
        homeViewModel.viewDidLoad()
    }

    private func setUpLayout() {
        view.makeToastActivity(.center)
    }

    private func setUpBinds() {
        homeViewModel.user
            .sink(receiveValue: { [weak self] _ in
                self?.view.hideToastActivity()
            })
            .store(in: &subscriptions)

        homeViewModel.presentRequestError
            .sink(receiveValue: { [weak self] _ in
                self?.view.hideToastActivity()
            })
            .store(in: &subscriptions)
    }
}
