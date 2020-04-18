//
//  RegistrationCredentials.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/18/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

struct RegistrationCredentials {
    let email: String
    let username: String
    let password: String
    let confirmPassword: String
    
    init(email: String,
         username: String,
         password: String,
         confirmPassword: String) {
        self.email = email
        self.username = username
        self.password = password
        self.confirmPassword = confirmPassword
    }
}

extension RegistrationCredentials {
    init?(email: String?,
         username: String?,
         password: String?,
         confirmPassword: String?) {
        if let email = email,
            let username = username,
            let password = password,
            let confirmPassword = confirmPassword,
            !email.isEmpty &&
                !username.isEmpty &&
                !password.isEmpty &&
                !confirmPassword.isEmpty {
            self.init(email: email,
                      username: username,
                      password: password,
                      confirmPassword: confirmPassword)
        } else {
            return nil
        }
    }
}

extension RegistrationCredentials {
    var isCorrectEmailFormat: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}
