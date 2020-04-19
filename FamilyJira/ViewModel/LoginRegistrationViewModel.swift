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
    var presentAuthError: PassthroughSubject<BaseError, Never> { get }
    var userLoggedIn: PassthroughSubject<Void, Never> { get }
    var registrationSucceed: PassthroughSubject<Void, Never> { get }
    
    func signInTapped(credentials: LoginCredentials?)
    func signUpTapped(credentials: RegistrationCredentials?)
}

final class LoginRegistrationViewModel: LoginRegistrationViewModelProtocol {
    let presentAuthError: PassthroughSubject<BaseError, Never>
    let userLoggedIn: PassthroughSubject<Void, Never>
    let registrationSucceed: PassthroughSubject<Void, Never>

    private let firebaseServise: FirebaseServiceProtocol
    private let reachabilityServis: ReachabilityServisProtocolol

    private var subscriptions = Set<AnyCancellable>()
    
    init(
        firebaseServise: FirebaseServiceProtocol = FamilyJiraDI.forceResolve(),
        reachabilityServis: ReachabilityServisProtocolol = FamilyJiraDI.forceResolve()
    ) {
        self.firebaseServise = firebaseServise
        self.reachabilityServis = reachabilityServis
        presentAuthError = PassthroughSubject<BaseError, Never>()
        userLoggedIn = PassthroughSubject<Void, Never>()
        registrationSucceed = PassthroughSubject<Void, Never>()
    }
    
    func signInTapped(credentials: LoginCredentials?) {
        guard reachabilityServis.isConnectedToNetwork() else {
            presentAuthError.send(LoginError.noConnection)
            return
        }
        firebaseServise.signIn(with: credentials)
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
    }
    
    func signUpTapped(credentials: RegistrationCredentials?) {
        guard reachabilityServis.isConnectedToNetwork() else {
            presentAuthError.send(RegistrationError.noConnection)
            return
        }
        firebaseServise.signUp(with: credentials)
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
