//
//  ProfileDTO.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/21/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

struct ProfileDTO {
    let username: String
    let role: String?
    let photoData: Data?
    
    init?(username: String?,
          role: String?,
          photoData: Data?) {
        if let username = username {
            self.username = username
            self.role = role
            self.photoData = photoData
        } else {
            return nil
        }
    }
}
