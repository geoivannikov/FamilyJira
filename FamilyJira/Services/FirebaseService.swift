//
//  FirebaseService.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/23/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import Combine

protocol FirebaseServiceProtocol {
    var isUserLoggedIn: Bool { get }
    func signIn(with loginCredentials: LoginCredentials?) -> Future<Void, LoginError>
    func signUp(with registrationCredentials: RegistrationCredentials?) -> Future<Void, RegistrationError>
}

final class FirebaseService: FirebaseServiceProtocol {
    private var userID: String? {
        let id = Auth.auth().currentUser?.uid
        return id
    }
    
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    func signIn(with loginCredentials: LoginCredentials?) -> Future<Void, LoginError> {
        Future<Void, LoginError> { promise in
            guard let credentials = loginCredentials else {
                promise(.failure(.validationError))
                return
            }
            Auth.auth().signIn(withEmail: credentials.email,
                               password: credentials.password) { result, error in
                if let error = error, let authErrorCode = AuthErrorCode(rawValue: error._code) {
                    let loginError = LoginError(authErrorCode: authErrorCode.rawValue)
                    promise(.failure(loginError))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    func signUp(with registrationCredentials: RegistrationCredentials?) -> Future<Void, RegistrationError> {
        Future<Void, RegistrationError> { promise in
            guard let credentials = registrationCredentials else {
                promise(.failure(.validationError))
                return
            }
            guard credentials.password == credentials.confirmPassword else {
                promise(.failure(.passwordsDoNotMatch))
                return
            }
            guard credentials.password.count > 5 else {
                promise(.failure(.passwordTooShort))
                return
            }
            guard credentials.isCorrectEmailFormat else {
                promise(.failure(.incorrectEmailFormat))
                return
            }
            Auth.auth().createUser(withEmail: credentials.email,
                                   password: credentials.password) { result, error in
              if let error = error, let authErrorCode = AuthErrorCode(rawValue: error._code) {
                  let registrationError = RegistrationError(authErrorCode: authErrorCode.rawValue)
                  promise(.failure(registrationError))
              } else {
                  promise(.success(()))
              }
            }
        }
    }
    
    func requestUser() -> Future<User, RequestError> {
        Future<User, RequestError> { promise in
            
        }
    }
}
