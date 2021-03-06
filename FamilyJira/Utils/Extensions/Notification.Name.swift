//
//  Notification.Name.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/20/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let userUpdated = Notification.Name("userUpdated")
    static let userLoggedIn = Notification.Name("userLoggedIn")
    static let userLoggedOut = Notification.Name("userLoggedOut")
    static let boardUpdated = Notification.Name("boardUpdated")
    static let profileImagePickedDismissed = Notification.Name("profileImagePickedDismissed")
}
