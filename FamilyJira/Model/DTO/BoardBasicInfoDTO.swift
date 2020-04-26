//
//  BoardBasicInfoDTO.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

struct BoardBasicInfoDTO {
    let id: String
    let name: String
    let photoData: Data?

    init?(name: String?,
          photoData: Data?) {
        if let name = name,
            !name.isEmpty {
            self.id = UUID().uuidString
            self.name = name
            self.photoData = photoData
        } else {
            return nil
        }
    }
}
