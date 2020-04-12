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
    let photoData: NSData?
    let name: String
    let role: String
    
    init(name: String, role: String) {
        let url = NSURL(string: link)! as URL
        self.photoData = NSData(contentsOf: url)
        self.name = name
        self.role = role
    }
}

extension ProfileSection: Hashable { }
