//
//  UIImage+.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit

extension UIImage {
    class var homeTab: UIImage? {
        return UIImage(named: "Home_iOS")
    }

    class var myTasksTab: UIImage? {
        return UIImage(named: "MyTasks_iOS")
    }

    class var settingsTab: UIImage? {
        return UIImage(named: "Settings_iOS")
    }
    
    class var privacyIcon: UIImage? {
        return UIImage(named: "privacy")
    }
    
    class var notificationsIcon: UIImage? {
        return UIImage(named: "notifications")
    }
    
    class var soundsIcon: UIImage? {
        return UIImage(named: "sounds")
    }
    
    class var licenseIcon: UIImage? {
        return UIImage(named: "license")
    }
}

extension UIImage {
    convenience init?(url: NSURL?) {
        guard let imageUrl = url as URL?,
            let imageData = try? Data(contentsOf: imageUrl) else {
            return nil
        }
        self.init(data: imageData)
    }
}
