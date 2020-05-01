//
//  FirebaseTests.swift
//  FamilyJiraTests
//
//  Created by George Ivannikov on 5/1/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import XCTest
import Combine
import Firebase
@testable import FamilyJira

// Add more tests (currently only login and registration tested)
class FirebaseTests: XCTestCase {
    var firebaseService: FirebaseService!
    var subscriptions: Set<AnyCancellable>!
    var testLoginCredentials: LoginCredentials!
    var testRegistrationCredentials: RegistrationCredentials!

    override func setUp() {
        FirebaseApp.configure()
        firebaseService = FirebaseService()
        try? firebaseService.signOut()
        testLoginCredentials = LoginCredentials(email: "test_user@gmail.com", password: "123456")
        testRegistrationCredentials = RegistrationCredentials(email: "test_user@gmail.com",
                                                              username: "test",
                                                              password: "123456",
                                                              confirmPassword: "123456")
        subscriptions = Set<AnyCancellable>()
    }

    func isUserLoggedIn() {
        let isLogin = firebaseService.isUserLoggedIn
        XCTAssertEqual(isLogin, false)
    }

    func testSuccessfulLogin() {
        expectationTest("Sign in", timeout: 10) { testExpectation in
            firebaseService.signIn(with: testLoginCredentials)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        ()
                    case .failure:
                        XCTFail("Unexpected error")
                    }
                }, receiveValue: {
                    testExpectation.fulfill()
                })
                .store(in: &subscriptions)
        }
    }

    func testFailureLoginIncorrectData() {
        testLoginCredentials = LoginCredentials(email: "incorrect_user@gmail.com", password: "123456")
        expectationTest("Sign in", shouldBeCompleted: false, timeout: 10) { _ in
            firebaseService.signIn(with: testLoginCredentials)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected finished")
                    case .failure(let error):
                        XCTAssertEqual(error, LoginError.incorrectData)
                    }
                }, receiveValue: {
                    XCTFail("Unexpected value")
                })
                .store(in: &subscriptions)
        }
    }

    func testFailureLoginIncorrectPassword() {
        testLoginCredentials = LoginCredentials(email: "test_user@gmail.com",
                                                password: "incorrect_password")
        expectationTest("Sign in", shouldBeCompleted: false, timeout: 10) { _ in
            firebaseService.signIn(with: testLoginCredentials)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected finished")
                    case .failure(let error):
                        XCTAssertEqual(error, LoginError.incorrectPassword)
                    }
                }, receiveValue: {
                    XCTFail("Unexpected value")
                })
                .store(in: &subscriptions)
        }
    }

    func testFailureLoginValidationError() {
        testLoginCredentials = nil
        expectationTest("Sign in", shouldBeCompleted: false, timeout: 10) { _ in
            firebaseService.signIn(with: testLoginCredentials)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected finished")
                    case .failure(let error):
                        XCTAssertEqual(error, LoginError.validationError)
                    }
                }, receiveValue: {
                    XCTFail("Unexpected value")
                })
                .store(in: &subscriptions)
        }
    }

    func testFailureRegistrationPasswordDoNotMatch() {
        testRegistrationCredentials = RegistrationCredentials(email: "test_user@gmail.com",
                                                              username: "test",
                                                              password: "1234567",
                                                              confirmPassword: "123456")
        expectationTest("Sign up", shouldBeCompleted: false, timeout: 10) { _ in
            firebaseService.signUp(with: testRegistrationCredentials)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected finished")
                    case .failure(let error):
                        XCTAssertEqual(error, RegistrationError.passwordsDoNotMatch)
                    }
                }, receiveValue: {
                    XCTFail("Unexpected value")
                })
                .store(in: &subscriptions)
        }
    }

    func testFailureRegistrationPasswordTooShort() {
        testRegistrationCredentials = RegistrationCredentials(email: "test_user@gmail.com",
                                                              username: "test",
                                                              password: "1234",
                                                              confirmPassword: "1234")
        expectationTest("Sign up", shouldBeCompleted: false, timeout: 10) { _ in
            firebaseService.signUp(with: testRegistrationCredentials)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected finished")
                    case .failure(let error):
                        XCTAssertEqual(error, RegistrationError.passwordTooShort)
                    }
                }, receiveValue: {
                    XCTFail("Unexpected value")
                })
                .store(in: &subscriptions)
        }
    }

    func testFailureRegistrationValidationError() {
        testRegistrationCredentials = nil
        expectationTest("Sign up", shouldBeCompleted: false, timeout: 10) { _ in
            firebaseService.signUp(with: testRegistrationCredentials)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected finished")
                    case .failure(let error):
                        XCTAssertEqual(error, RegistrationError.validationError)
                    }
                }, receiveValue: {
                    XCTFail("Unexpected value")
                })
                .store(in: &subscriptions)
        }
    }

    func testFailureRegistrationUserAlreadyExists() {
        testRegistrationCredentials = RegistrationCredentials(email: "test_user@gmail.com",
                                                              username: "test",
                                                              password: "123456",
                                                              confirmPassword: "123456")
        expectationTest("Sign up", shouldBeCompleted: false, timeout: 10) { _ in
            firebaseService.signUp(with: testRegistrationCredentials)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Unexpected finished")
                    case .failure(let error):
                        XCTAssertEqual(error, RegistrationError.userAlreadyExists)
                    }
                }, receiveValue: {
                    XCTFail("Unexpected value")
                })
                .store(in: &subscriptions)
        }
    }
}
