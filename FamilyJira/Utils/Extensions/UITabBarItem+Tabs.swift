//
//  UITabBarItem+Tabs.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit

extension UITabBarItem {
    convenience init(_ tab: Tabs) {
        self.init(title: tab.title, image: tab.image, tag: tab.rawValue)
    }
}
