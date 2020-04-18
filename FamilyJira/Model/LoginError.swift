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
    case unknownError
}

extension LoginError {
    init(authErrorCode: Int) {
        switch authErrorCode {
        case 17008:
            self = .incorrectData
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
            return "Incorrect login or password"
        default:
            return "Unknown error"
        }
    }
}
