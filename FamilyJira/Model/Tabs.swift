//
//  Tabs.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit

enum Tabs: Int {
    case home = 1
    case myTasks = 2
    case settings = 3
}

extension Tabs {
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .myTasks:
            return "My Tasks"
        case .settings:
            return "Settings"
        }
    }
}

extension Tabs {
    var image: UIImage? {
        switch self {
        case .home:
            return UIImage.homeTab
        case .myTasks:
            return UIImage.myTasksTab
        case .settings:
            return UIImage.settingsTab
        }
    }
}
