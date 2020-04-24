//
//  UserObject.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import RealmSwift

final class UserObject: Object, RealmObject {
    @objc dynamic private(set) var id: String = ""
    @objc dynamic private(set) var email: String = ""
    @objc dynamic private(set) var username: String = ""
    @objc dynamic private(set) var role: String? = nil
    @objc dynamic private(set) var photoData: NSData?
    @objc dynamic private(set) var boardId: String? = nil

    convenience init(model: UserDTO) {
        self.init()
        self.id = model.id
        self.email = model.email
        self.username = model.username
        self.role = model.role
        self.boardId = model.boardId
        
        if let urlString = model.photoUrl,
            let url = NSURL(string: urlString) {
            self.photoData = NSData(contentsOf: url as URL)
        }
    }
}

extension UserObject {
    convenience init(user: UserObject, profile: ProfileDTO) {
        self.init()
        self.id = user.id
        self.email = user.email
        self.username = profile.username
        self.role = profile.role
        self.boardId = user.boardId
        self.photoData = profile.photoData as NSData?
    }
}
