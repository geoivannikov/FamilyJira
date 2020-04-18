//
//  UIAlertController+.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func errorAlert(content: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: content, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
}
