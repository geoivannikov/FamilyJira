//
//  LoginCredentials.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/17/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

struct LoginCredentials {
    let email: String
    let password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension LoginCredentials {
    init?(email: String?, password: String?) {
        if let email = email,
            let password = password,
            !email.isEmpty && !password.isEmpty {
            self.init(email: email, password: password)
        } else {
            return nil
        }
    }
}
