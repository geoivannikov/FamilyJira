//
//  LoginRegistrationViewModelTests.swift
//  FamilyJiraTests
//
//  Created by George Ivannikov on 4/29/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import XCTest
import Combine
@testable import FamilyJira

class LoginRegistrationViewModelTests: XCTestCase {
    var viewModel: LoginRegistrationViewModel!
    var subscriptions: Set<AnyCancellable>!

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
    }

    func testSuccessfulLogin() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .success),
                                               reachabilityServis: ReachabilityServiceMock())

        let testExpectation = expectation(description: "Sign in")
        viewModel.userLoggedIn
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    ()
                case .failure:
                    XCTFail("Unexpected error")
                }
            }, receiveValue: { _ in
                testExpectation.fulfill()
            })
            .store(in: &subscriptions)

        let loginCredentials = LoginCredentials(email: "email", password: "password")
        viewModel.signInTapped(credentials: loginCredentials)
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testFailureLoginIncorrectDataLogin() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .failureLogin(.incorrectData)),
                                               reachabilityServis: ReachabilityServiceMock())

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? LoginError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, LoginError.incorrectData)
            })
            .store(in: &subscriptions)

        let loginCredentials = LoginCredentials(email: "email", password: "password")
        viewModel.signInTapped(credentials: loginCredentials)
    }

    func testFailureLoginIncorrectPasswordLogin() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .failureLogin(.incorrectPassword)),
                                               reachabilityServis: ReachabilityServiceMock())

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? LoginError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, LoginError.incorrectPassword)
            })
            .store(in: &subscriptions)

        let loginCredentials = LoginCredentials(email: "email", password: "password")
        viewModel.signInTapped(credentials: loginCredentials)
    }

    func testFailureLoginValidationErrorLogin() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .failureLogin(.validationError)),
                                               reachabilityServis: ReachabilityServiceMock())

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? LoginError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, LoginError.validationError)
            })
            .store(in: &subscriptions)

        let loginCredentials = LoginCredentials(email: "email", password: "password")
        viewModel.signInTapped(credentials: loginCredentials)
    }

    func testFailureLoginNoConnectionLogin() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .success),
                                               reachabilityServis: ReachabilityServiceMock(isConnected: false))

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? LoginError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, LoginError.noConnection)
            })
            .store(in: &subscriptions)

        let loginCredentials = LoginCredentials(email: "email", password: "password")
        viewModel.signInTapped(credentials: loginCredentials)
    }

    func testSuccessfulRegistration() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .success),
                                               reachabilityServis: ReachabilityServiceMock())

        let testExpectation = expectation(description: "Sign up")
        viewModel.registrationSucceed
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    ()
                case .failure:
                    XCTFail("Unexpected error")
                }
            }, receiveValue: { _ in
                testExpectation.fulfill()
            })
            .store(in: &subscriptions)

        let registrationCredentials = RegistrationCredentials(email: "email",
                                                              username: "username",
                                                              password: "password",
                                                              confirmPassword: "password")
        viewModel.signUpTapped(credentials: registrationCredentials)
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testFailureRegistrationIncorrectFormat() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .failureRegistration(.incorrectEmailFormat)),
                                               reachabilityServis: ReachabilityServiceMock())

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? RegistrationError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, RegistrationError.incorrectEmailFormat)
            })
            .store(in: &subscriptions)

        let registrationCredentials = RegistrationCredentials(email: "email",
                                                              username: "username",
                                                              password: "password",
                                                              confirmPassword: "password")
        viewModel.signUpTapped(credentials: registrationCredentials)
    }

    func testFailureRegistrationPasswordDoNotMatch() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .failureRegistration(.passwordsDoNotMatch)),
                                               reachabilityServis: ReachabilityServiceMock())

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? RegistrationError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, RegistrationError.passwordsDoNotMatch)
            })
            .store(in: &subscriptions)

        let registrationCredentials = RegistrationCredentials(email: "email",
                                                              username: "username",
                                                              password: "password",
                                                              confirmPassword: "password")
        viewModel.signUpTapped(credentials: registrationCredentials)
    }

    func testFailureRegistrationPasswordTooShort() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .failureRegistration(.passwordTooShort)),
                                               reachabilityServis: ReachabilityServiceMock())

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? RegistrationError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, RegistrationError.passwordTooShort)
            })
            .store(in: &subscriptions)

        let registrationCredentials = RegistrationCredentials(email: "email",
                                                              username: "username",
                                                              password: "password",
                                                              confirmPassword: "password")
        viewModel.signUpTapped(credentials: registrationCredentials)
    }

    func testFailureRegistrationValidationError() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .failureRegistration(.validationError)),
                                               reachabilityServis: ReachabilityServiceMock())

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? RegistrationError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, RegistrationError.validationError)
            })
            .store(in: &subscriptions)

        let registrationCredentials = RegistrationCredentials(email: "email",
                                                              username: "username",
                                                              password: "password",
                                                              confirmPassword: "password")
        viewModel.signUpTapped(credentials: registrationCredentials)
    }

    func testFailureRegistrationNoConnectionError() {
        viewModel = LoginRegistrationViewModel(firebaseServise: FirebaseServiceMock(isUserLoggedIn: false,
                                                                                    useCase: .success),
                                               reachabilityServis: ReachabilityServiceMock(isConnected: true))

        viewModel.presentAuthError
            .sink(receiveValue: { error in
                guard let error = error as? RegistrationError else {
                    XCTFail("Incorrect error type")
                    return
                }
                XCTAssertEqual(error, RegistrationError.noConnection)
            })
            .store(in: &subscriptions)

        let registrationCredentials = RegistrationCredentials(email: "email",
                                                              username: "username",
                                                              password: "password",
                                                              confirmPassword: "password")
        viewModel.signUpTapped(credentials: registrationCredentials)
    }
}
