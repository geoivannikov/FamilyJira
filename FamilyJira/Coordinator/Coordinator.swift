//
//  Coordinator.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func presentError(error: BaseError)
}

extension Coordinator {
    func presentError(error: BaseError) {
        let alert = UIAlertController.errorAlert(content: error.errorMessage())
        navigationController.present(alert, animated: true)
    }
}
