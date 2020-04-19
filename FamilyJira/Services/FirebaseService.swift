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
    func signIn(with loginCredentials: LoginCredentials?) -> AnyPublisher<Void, LoginError>
    func signUp(with registrationCredentials: RegistrationCredentials?) -> AnyPublisher<Void, RegistrationError>
    func signOut() throws
}

final class FirebaseService: FirebaseServiceProtocol {
    private var userID: String? {
        let id = Auth.auth().currentUser?.uid
        return id
    }
    
    private var databaseReference: DatabaseReference {
        Database.database().reference()
    }
    
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser?.uid != nil
    }
    
    func signIn(with loginCredentials: LoginCredentials?) -> AnyPublisher<Void, LoginError> {
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
        .flatMap {
            Future<Void, LoginError> { promise in
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(with registrationCredentials: RegistrationCredentials?) -> AnyPublisher<Void, RegistrationError> {
        Future<RegistrationCredentials, RegistrationError> { promise in
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
                    promise(.success(credentials))
                }
            }
        }
        .flatMap { credentials in
            Future<Void, RegistrationError> { [weak self] promise in
                guard let ref = self?.databaseReference,
                    let id = self?.userID else {
                    promise(.failure(.unknownError))
                    return
                }
                ref.child("users").child(id).setValue(["email": credentials.email,
                                                       "username": credentials.username])
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func requestUser() -> Future<User, RequestError> {
        Future<User, RequestError> { promise in
            
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
