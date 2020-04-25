//
//  PreferencesSection.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/11/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

struct PreferencesSection {
    let icon: UIImage?
    let title: String

    init(icon: UIImage?, title: String) {
        self.icon = icon
        self.title = title
    }
}

extension PreferencesSection: Hashable { }
