//
//  RequestError.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/18/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

enum RequestError: BaseError {
    case noConnection
    case serverError
    case unknownError
}

extension RequestError {
    func errorMessage() -> String {
        switch self {
        case .serverError:
            return "Some errors on the server"
        case .noConnection:
            return "Check your internet connection"
        default:
            return "Unknown error"
        }
    }
}
