//
//  LoginCredentialsTests.swift
//  FamilyJiraTests
//
//  Created by George Ivannikov on 5/1/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import XCTest
@testable import FamilyJira

// Add more tests (currently only login and registration tested)
class LoginCredentialsTests: XCTestCase {
    var testLoginCredentials: LoginCredentials!

    override func setUp() {
       testLoginCredentials = LoginCredentials(email: "email", password: "password")
    }

    func testCredentialsNotNil() {
        XCTAssertNotNil(testLoginCredentials)
    }

    func testCredentialsEmailNil() {
        testLoginCredentials = LoginCredentials(email: nil, password: "password")
        XCTAssertNil(testLoginCredentials)
    }

    func testCredentialsPasswordNil() {
        testLoginCredentials = LoginCredentials(email: "email", password: nil)
        XCTAssertNil(testLoginCredentials)
    }
}
