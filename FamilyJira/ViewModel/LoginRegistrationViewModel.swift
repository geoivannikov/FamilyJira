//
//  LoginRegistrationViewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/26/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine

//case emptyField
//case emailValidation
//case passwordTooShort
//case passwordsDoNotMatch
//case noInternetConnection

protocol LoginRegistrationViewModelProtocol {
    var email: CurrentValueSubject<String, Never> { get }
    var username: CurrentValueSubject<String, Never> { get }
    var password: CurrentValueSubject<String, Never> { get }
    var confirmPassword: CurrentValueSubject<String, Never> { get }
    
    var signInTapped: Empty<Void, Never> { get }
}

final class LoginRegistrationViewModel: LoginRegistrationViewModelProtocol {
    var email = CurrentValueSubject<String, Never>("")
    var username = CurrentValueSubject<String, Never>("")
    var password = CurrentValueSubject<String, Never>("")
    var confirmPassword = CurrentValueSubject<String, Never>("")
    
    let signInTapped = Empty<Void, Never>()
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        firebaseService: FirebaseServiceProtocol = FamilyJiraDI.forceResolve()
    ) {
        firebaseService.signIn(email: "george8@rambler.ru", password: "12345678")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(_):
                    print("Failure")
                }
            }, receiveValue: { value in
                print(value)
            })
            .store(in: &subscriptions)
    }
}
