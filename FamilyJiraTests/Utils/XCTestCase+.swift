//
//  XCTestCase+.swift
//  FamilyJiraTests
//
//  Created by George Ivannikov on 5/1/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func expectationTest(_ description: String,
                         shouldBeCompleted: Bool = true,
                         timeout: Double,
                         with body: (XCTestExpectation) -> Void) {
        let testExpectation = expectation(description: description)
        body(testExpectation)
        let result = XCTWaiter().wait(for: [testExpectation], timeout: timeout)
        if shouldBeCompleted {
            XCTAssertEqual(result, .completed)
        }
    }
}
