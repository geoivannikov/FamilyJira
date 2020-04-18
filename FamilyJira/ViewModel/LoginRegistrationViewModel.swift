//
//  LoginRegistrationViewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine

protocol LoginRegistrationViewModelProtocol {
    var signInTapped: PassthroughSubject<LoginCredentials?, LoginError> { get }
    var signUpTapped: PassthroughSubject<RegistrationCredentials?, RegistrationError> { get }
    var presentAuthError: PassthroughSubject<BaseError, Never> { get }
    var userLoggedIn: PassthroughSubject<Void, Never> { get }
    var registrationSucceed: PassthroughSubject<Void, Never> { get }
}

final class LoginRegistrationViewModel: LoginRegistrationViewModelProtocol {
    let signInTapped: PassthroughSubject<LoginCredentials?, LoginError>
    let signUpTapped: PassthroughSubject<RegistrationCredentials?, RegistrationError>
    let presentAuthError: PassthroughSubject<BaseError, Never>
    let userLoggedIn: PassthroughSubject<Void, Never>
    let registrationSucceed: PassthroughSubject<Void, Never>

    private var subscriptions = Set<AnyCancellable>()
    
    init(
        firebaseService: FirebaseServiceProtocol = FamilyJiraDI.forceResolve(),
        reachabilityServis: ReachabilityServisProtocolol = FamilyJiraDI.forceResolve()
    ) {
        signInTapped = PassthroughSubject<LoginCredentials?, LoginError>()
        signUpTapped = PassthroughSubject<RegistrationCredentials?, RegistrationError>()
        presentAuthError = PassthroughSubject<BaseError, Never>()
        userLoggedIn = PassthroughSubject<Void, Never>()
        registrationSucceed = PassthroughSubject<Void, Never>()
        
        signInTapped
            .flatMap { credentials -> Future<Void, LoginError> in
                if reachabilityServis.isConnectedToNetwork() {
                    return firebaseService.signIn(with: credentials)
                } else {
                    return Future<Void, LoginError> {
                        $0(.failure(.noConnection))
                    }
                }
            }
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    self?.presentAuthError.send(error)
                }
            }, receiveValue: { [weak self] _ in
                self?.userLoggedIn.send()
            })
            .store(in: &subscriptions)
        
        signUpTapped
            .flatMap { credentials -> Future<Void, RegistrationError> in
                if reachabilityServis.isConnectedToNetwork() {
                    return firebaseService.signUp(with: credentials)
                } else {
                    return Future<Void, RegistrationError> {
                        $0(.failure(.noConnection))
                    }
                }
            }
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    self?.presentAuthError.send(error)
                }
            }, receiveValue: { [weak self] _ in
                self?.registrationSucceed.send()
            })
            .store(in: &subscriptions)
    }
}
