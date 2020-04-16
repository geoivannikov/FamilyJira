//
//  HomeViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    static func instantiate() -> HomeViewController {
        let viewController: HomeViewController = HomeViewController()
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    private func setUpLayout() {

    }
}
