//
//  FirebaseService.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/23/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Combine

protocol FirebaseServiceProtocol {
    var isUserLoggedIn: Bool { get }
    func signIn(with loginCredentials: LoginCredentials?) -> AnyPublisher<Void, LoginError>
    func signUp(with registrationCredentials: RegistrationCredentials?) -> AnyPublisher<Void, RegistrationError>
    func signOut() throws
    func requestUser() -> AnyPublisher<UserDTO, RequestError>
    func updateProfile(profileDTO: ProfileDTO) -> AnyPublisher<ProfileDTO, UpdateProfileError>
}

final class FirebaseService: FirebaseServiceProtocol {
    private var userID: String? {
        Auth.auth().currentUser?.uid
    }

    private var databaseReference: DatabaseReference = {
        Database.database().reference()
    }()

    private var storageReference: StorageReference {
        Storage.storage().reference()
    }

    var isUserLoggedIn: Bool {
        Auth.auth().currentUser?.uid != nil
    }

    func signIn(with loginCredentials: LoginCredentials?) -> AnyPublisher<Void, LoginError> {
        Future<Void, LoginError> { promise in
            guard let credentials = loginCredentials else {
                promise(.failure(.validationError))
                return
            }
            Auth.auth().signIn(withEmail: credentials.email,
                               password: credentials.password) { _, error in
                if let error = error, let authErrorCode = AuthErrorCode(rawValue: error._code) {
                    print(authErrorCode.rawValue)
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
                                   password: credentials.password) { _, error in
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

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func requestUser() -> AnyPublisher<UserDTO, RequestError> {
        Future<UserDTO, RequestError> { [weak self] promise in
            guard let ref = self?.databaseReference,
                let id = self?.userID else {
                promise(.failure(.unknownError))
                return
            }
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as? NSDictionary
                guard let user = UserDTO(snapshot: value, id: id) else {
                    promise(.failure(.serverError))
                    return
                }
                promise(.success(user))
            })
        }
        .eraseToAnyPublisher()
    }

    func updateProfile(profileDTO: ProfileDTO) -> AnyPublisher<ProfileDTO, UpdateProfileError> {
        Future<ProfileDTO, UpdateProfileError> { [weak self] promise in
            guard let ref = self?.databaseReference,
                let id = self?.userID else {
                promise(.failure(.unknownError))
                return
            }
            ref.child("users").child(id).updateChildValues(["username": profileDTO.username,
                                                            "role": profileDTO.role ?? ""])
            promise(.success(profileDTO))
        }
        .flatMap { [weak self] profileDTO in
            self?.uploadProfilePhoto(profileDTO: profileDTO) ??
                Future<ProfileDTO, UpdateProfileError> { $0(.failure(.unknownError)) }
        }
        .eraseToAnyPublisher()
    }

    func uploadProfilePhoto(profileDTO: ProfileDTO) -> Future<ProfileDTO, UpdateProfileError> {
        Future<ProfileDTO, UpdateProfileError> { [weak self] promise in
            guard let data = profileDTO.photoData else {
                promise(.success(profileDTO))
                return
            }
            guard let storage = self?.storageReference,
                let id = self?.userID else {
                promise(.failure(.unknownError))
                return
            }
            storage.child("users").child(id).putData(data,
                                                 metadata: nil,
                                                 completion: { _, error in
                guard error == nil else {
                    promise(.failure(.serverError))
                    return
                }
                storage.child("users").child(id).downloadURL { url, error in
                    if let error = error {
                        promise(.failure(UpdateProfileError(error: error)))
                        return
                    } else {
                        guard let ref = self?.databaseReference,
                            let photoUrl = url else {
                            promise(.failure(.unknownError))
                            return
                        }
                        ref.child("users").child(id).updateChildValues(["profilePhoto": photoUrl.absoluteString])
                        promise(.success(profileDTO))
                    }
                }
            })
        }
    }
}
