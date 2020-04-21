//
//  LoginError.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

enum LoginError: BaseError {
    case validationError
    case noConnection
    case incorrectData
    case incorrectPassword
    case unknownError
}

extension LoginError {
    init(authErrorCode: Int) {
        switch authErrorCode {
        case 17008:
            self = .incorrectData
        case 17011:
            self = .incorrectData
        case 17009:
            self = .incorrectPassword
        /* TODO: Add new auth error cases */
        default:
            self = .unknownError
        }
    }
}

extension LoginError {
    func errorMessage() -> String {
        switch self {
        case .validationError:
            return "All fields must be filled"
        case .noConnection:
            return "Check your internet connection"
        case .incorrectData:
            return "Incorrect credentials"
        case .incorrectPassword:
            return "Incorrect password"
        default:
            return "Unknown error"
        }
    }
}
