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
    @objc dynamic private(set) var photoUrl: String? = nil
    @objc dynamic private(set) var boardId: String? = nil

    convenience init(model: UserDTO) {
        self.init()
        self.id = model.id
        self.email = model.email
        self.username = model.username
        self.role = model.role
        self.photoUrl = model.photoUrl
        self.boardId = model.boardId
    }
}
