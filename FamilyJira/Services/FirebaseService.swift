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
    func signIn(email: String, password: String) -> Future<User, LoginError>
}

final class FirebaseService: FirebaseServiceProtocol {
    private var userID: String? {
        let id = Auth.auth().currentUser?.uid
        return id
    }
    
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    func signIn(email: String, password: String) -> Future<User, LoginError> {
        let signInPublisher = Future<User, LoginError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error, let authErrorCode = AuthErrorCode(rawValue: error._code) {
                    let loginError = LoginError(authErrorCode: authErrorCode.rawValue)
                    promise(.failure(loginError))
                } else {
                    promise(.success(User()))
                }
            }
        }
        return signInPublisher
    }
}
