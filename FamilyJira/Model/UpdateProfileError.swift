//
//  UpdateProfileError.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/21/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

enum UpdateProfileError: BaseError {
    case noConnection
    case serverError
    case validationError
    case unknownError
}

extension UpdateProfileError {
    init(error: Error) {
        /* TODO: Add new auth error cases */
        self = .serverError
    }
}

extension UpdateProfileError {
    func errorMessage() -> String {
        switch self {
        case .serverError:
            return "Some errors on the server"
        case .noConnection:
            return "Check your internet connection"
        case .validationError:
            return "Username can not be empty"
        default:
            return "Unknown error"
        }
    }
}
