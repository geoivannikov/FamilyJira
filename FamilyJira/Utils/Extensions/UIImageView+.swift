//
//  UIImageView+.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/11/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRounded(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
