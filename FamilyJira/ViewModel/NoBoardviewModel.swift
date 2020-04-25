//
//  NoBoardviewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/25/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine

protocol NoBoardViewModelProtocol {
    var joinBoardTapped: PassthroughSubject<Void, Never> { get }
}

final class NoBoardViewModel: NoBoardViewModelProtocol {
    let joinBoardTapped: PassthroughSubject<Void, Never>

    init(
        reachabilityServis: ReachabilityServisProtocolol = FamilyJiraDI.forceResolve()
    ) {
        joinBoardTapped = PassthroughSubject<Void, Never>()
    }
}
