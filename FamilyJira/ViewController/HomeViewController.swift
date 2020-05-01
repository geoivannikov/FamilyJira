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
import BTNavigationDropdownMenu

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

        let items = ["Tasks", "Members", "Settings"]
        let menuView = BTNavigationDropdownMenu(title: BTTitle.index(0), items: items)
        menuView.arrowTintColor = .black
        menuView.navigationBarTitleFont = UIFont.boldSystemFont(ofSize: 17)
        menuView.cellTextLabelFont = UIFont.systemFont(ofSize: 16)
        menuView.cellSeparatorColor = .white
        menuView.cellTextLabelAlignment = .center
        menuView.checkMarkImage = .strokedCheckmark
        self.navigationItem.titleView = menuView
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

        homeViewModel.board
            .sink(receiveValue: {
                print("Success \($0)")
            })
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: .boardUpdated, object: nil)
            .sink(receiveValue: { [weak self] _ in
                self?.view.makeToastActivity(.center)
            })
            .store(in: &subscriptions)
    }
}
