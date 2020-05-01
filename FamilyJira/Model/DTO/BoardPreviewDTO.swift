//
//  BoardPreviewDTO.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

struct BoardPreviewDTO {
    let name: String
    let photo: Data?

    init(name: String, photo: Data?) {
        self.photo = photo
        self.name = name
    }
}
