//
//  RegistrationError.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/18/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

enum RegistrationError: BaseError {
    case validationError
    case noConnection
    case incorrectEmailFormat
    case passwordTooShort
    case passwordsDoNotMatch
    case userAlreadyExists
    case unknownError
}

extension RegistrationError {
    init(authErrorCode: Int) {
        switch authErrorCode {
        case 17007:
            self = .userAlreadyExists
        /* TODO: Add new auth error cases */
        default:
            self = .unknownError
        }
    }
}

extension RegistrationError {
    func errorMessage() -> String {
        switch self {
        case .validationError:
            return "All fields must be filled"
        case .noConnection:
            return "Check your internet connection"
        case .incorrectEmailFormat:
            return "Email format is incorrect"
        case .passwordTooShort:
            return "Password must be longer than 5 characters"
        case .passwordsDoNotMatch:
            return "Passwords do not match"
        case .userAlreadyExists:
            return "User with this data already exists."
        default:
            return "Unknown error"
        }
    }
}
