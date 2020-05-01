//
//  RegistrationCredentialsTests.swift
//  FamilyJiraTests
//
//  Created by George Ivannikov on 5/1/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import XCTest
@testable import FamilyJira

// Add more tests (currently only login and registration tested)
class RegistrationCredentialsTests: XCTestCase {
    var registrationCredentials: RegistrationCredentials!

    override func setUp() {
       registrationCredentials = RegistrationCredentials(email: "email",
                                                         username: "username",
                                                         password: "password",
                                                         confirmPassword: "password")
    }

    func testCredentialsNotNil() {
        XCTAssertNotNil(registrationCredentials)
    }

    func testCredentialsEmailNil() {
        registrationCredentials = RegistrationCredentials(email: nil,
                                                          username: "username",
                                                          password: "password",
                                                          confirmPassword: "password")
        XCTAssertNil(registrationCredentials)
    }

    func testCredentialsUsernameNil() {
        registrationCredentials = RegistrationCredentials(email: "email",
                                                          username: nil,
                                                          password: "password",
                                                          confirmPassword: "password")
        XCTAssertNil(registrationCredentials)
    }

    func testCredentialsPasswordNil() {
        registrationCredentials = RegistrationCredentials(email: "email",
                                                          username: "username",
                                                          password: nil,
                                                          confirmPassword: "password")
        XCTAssertNil(registrationCredentials)
    }

    func testCredentialsConfirmPasswordNil() {
        registrationCredentials = RegistrationCredentials(email: "email",
                                                          username: "username",
                                                          password: "password",
                                                          confirmPassword: nil)
        XCTAssertNil(registrationCredentials)
    }
}
