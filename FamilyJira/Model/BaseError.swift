//
//  BaseError.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

protocol BaseError: Error {
    func errorMessage() -> String
}
