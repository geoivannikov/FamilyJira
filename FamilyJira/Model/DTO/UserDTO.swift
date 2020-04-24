//
//  UserDTO.swift
//  FamilyJira
//
//  Created by George Ivannikov on 3/3/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

struct UserDTO {
    let id: String
    let username: String
    let email: String
    let role: String?
    let photoUrl: String?
    let boardId: String?
    
    init(id: String,
         email: String,
         username: String,
         role: String?,
         photoUrl: String?,
         boardId: String?) {
        self.id = id
        self.email = email
        self.username = username
        self.role = role
        self.photoUrl = photoUrl
        self.boardId = boardId
    }
    
    init?(snapshot: NSDictionary?, id: String) {
        guard let email = snapshot?["email"] as? String,
            let username = snapshot?["username"] as? String else {
                return nil
        }
        let role = snapshot?["role"] as? String
        let photoUrl = snapshot?["profilePhoto"] as? String
        let boardId = snapshot?["boardId"] as? String
        self.init(id: id,
                  email: email,
                  username: username,
                  role: role,
                  photoUrl: photoUrl,
                  boardId: boardId)
    }
}
