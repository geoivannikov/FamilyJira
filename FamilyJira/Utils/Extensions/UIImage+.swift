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
        UIImage(named: "Home_iOS")
    }

    class var myTasksTab: UIImage? {
        UIImage(named: "MyTasks_iOS")
    }

    class var settingsTab: UIImage? {
        UIImage(named: "Settings_iOS")
    }

    class var privacyIcon: UIImage? {
        UIImage(named: "privacy")
    }

    class var notificationsIcon: UIImage? {
        UIImage(named: "notifications")
    }

    class var soundsIcon: UIImage? {
        UIImage(named: "sounds")
    }

    class var licenseIcon: UIImage? {
        UIImage(named: "license")
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

extension UIImage {
    var mediumQualityJPEGNSData: Data? {
        jpegData(compressionQuality: 0.4)
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
