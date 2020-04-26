//
//  BoardObject.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import RealmSwift

final class BoardObject: Object, RealmObject {
    @objc dynamic private(set) var id: String = ""
    @objc dynamic private(set) var photoData: NSData?
    @objc dynamic private(set) var creator: UserObject?
    @objc dynamic var members: [UserObject] {
        Array(membersList)
    }
    @objc dynamic var tasks: [TaskObject] {
        Array(tasksList)
    }

    private(set) var membersList = List<UserObject>()
    private(set) var tasksList = List<TaskObject>()
}

extension BoardObject {
    convenience init(model: BoardBasicInfoDTO, user: UserObject) {
        self.init()
        self.id = model.id
        self.photoData = model.photoData as NSData?
        self.creator = user
        self.membersList.append(user)
    }
}
