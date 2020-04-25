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
}

final class NoBoardViewModel: NoBoardViewModelProtocol {
    init(
        reachabilityServis: ReachabilityServisProtocolol = FamilyJiraDI.forceResolve()
    ) {
    }
}
