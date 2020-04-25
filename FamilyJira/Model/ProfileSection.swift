//
//  Profile.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/11/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

let link = "https://i.pinimg.com/474x/87/13/62/871362c61b14c0e39528af5c9dafd2ca.jpg"

struct ProfileSection {
    let username: String
    let role: String?
    let photoData: NSData?

    init(username: String, role: String?, photoData: NSData?) {
        self.username = username
        self.role = role
        self.photoData = photoData
    }
}

extension ProfileSection: Hashable { }
