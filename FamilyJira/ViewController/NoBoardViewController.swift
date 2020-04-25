//
//  NoBoardViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/16/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

class NoBoardViewController: UIViewController {
    private var noBoardViewModel: NoBoardViewModelProtocol!
    private let noBoardView = NoBoardView()
    private let createBoardPopUp = CreateBoardPopUp()

    private var subscriptions = Set<AnyCancellable>()

    static func instantiate(
        noBoardViewModel: NoBoardViewModelProtocol
    ) -> NoBoardViewController {
        let viewController: NoBoardViewController = NoBoardViewController()
        viewController.noBoardViewModel = noBoardViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpBinds()
    }

    private func setUpLayout() {
        view.backgroundColor = .backgroundBlue
        navigationItem.setHidesBackButton(true, animated: false)

        view.addSubview(noBoardView)
        noBoardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(createBoardPopUp)
        createBoardPopUp.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setUpBinds() {
        noBoardView.createButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.createBoardPopUp.animateIn()
            })
            .store(in: &subscriptions)

        noBoardView.joinButton
            .publisher(for: .touchUpInside)
            .sink(receiveValue: { [weak self] _ in
                self?.noBoardViewModel.joinBoardTapped.send()
            })
            .store(in: &subscriptions)
    }
}
