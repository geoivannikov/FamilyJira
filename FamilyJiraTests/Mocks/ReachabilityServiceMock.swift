//
//  ReachabilityServiceMock.swift
//  FamilyJiraTests
//
//  Created by George Ivannikov on 4/29/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

@testable import FamilyJira

final class ReachabilityServiceMock: ReachabilityServisProtocolol {
    private let isConnected: Bool

    func isConnectedToNetwork() -> Bool {
        isConnected
    }

    init(isConnected: Bool = true) {
        self.isConnected = isConnected
    }
}
