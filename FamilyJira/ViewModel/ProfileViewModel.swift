//
//  ProfileViewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

protocol ProfileViewModelProtocol {
    
}

final class ProfileViewModel: ProfileViewModelProtocol {
    init(
        firebaseService: FirebaseServiceProtocol = FamilyJiraDI.forceResolve()
    ) { }
}
