//
//  HomeViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private var homeViewModel: HomeViewModelProtocol!
    
    static func instantiate(homeViewModel: HomeViewModelProtocol) -> HomeViewController {
        let viewController: HomeViewController = HomeViewController()
        viewController.homeViewModel = homeViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        homeViewModel.viewDidLoad()
    }
    
    private func setUpLayout() {

    }
}
