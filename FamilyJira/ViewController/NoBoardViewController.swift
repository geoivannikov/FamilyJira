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
    }

    private func setUpLayout() {
        view.backgroundColor = .backgroundBlue
        navigationItem.setHidesBackButton(true, animated: false)

        view.addSubview(noBoardView)
        noBoardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
