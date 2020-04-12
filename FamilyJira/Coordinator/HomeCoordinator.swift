//
//  HomeCoordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/23/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

final class HomeCoordinator {
    let navigationController: UINavigationController
    
    init() {
        let homeViewController = HomeViewController.instantiate()
        navigationController = UINavigationController( rootViewController: homeViewController)
    }
}
