//
//  CreateBoardError.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

enum CreateBoardError: BaseError {
    case noConnection
    case serverError
    case validationError
    case unknownError
}

extension CreateBoardError {
    init(error: Error) {
        /* TODO: Add new error cases */
        self = .serverError
    }
}

extension CreateBoardError {
    func errorMessage() -> String {
        switch self {
        case .serverError:
            return "Some errors on the server"
        case .noConnection:
            return "Check your internet connection"
        case .validationError:
            return "Family name can not be empty"
        default:
            return "Unknown error"
        }
    }
}
