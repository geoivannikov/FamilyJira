//
//  SearchBoardViewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/25/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine

protocol SearchBoardViewModelProtocol {
}

final class SearchBoardViewModel: SearchBoardViewModelProtocol {
    init(
        firebaseServise: FirebaseServiceProtocol = FamilyJiraDI.forceResolve(),
        reachabilityService: ReachabilityServisProtocolol = FamilyJiraDI.forceResolve(),
        realmService: RealmServiceProtocol = FamilyJiraDI.forceResolve()
    ) {
    }
}
