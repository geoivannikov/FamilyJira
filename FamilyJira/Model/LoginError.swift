//
//  LoginError.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

struct LoginError: Error {
    enum LoginErrorType {
        case incorrectData
        case unknownError
    }
    
    private let loginErrorType: LoginErrorType
    
    init(authErrorCode: Int) {
        switch authErrorCode {
        case 17009:
            loginErrorType = .incorrectData
        default:
            loginErrorType = .unknownError
        }
    }
}
