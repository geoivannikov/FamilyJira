//
//  BoardPreview.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

struct BoardPreview {
    let icon: UIImage?
    let name: String

    init(icon: UIImage?, name: String) {
        self.icon = icon
        self.name = name
    }
}

extension BoardPreview: Hashable { }
