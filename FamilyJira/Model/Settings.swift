//
//  Settings.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/11/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation

enum Settings {
    case profile(ProfileSection)
    case preferences(PreferencesSection)
    case logOut
}

extension Settings: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .profile(let profile):
            hasher.combine(profile)
        case .preferences(let preferences):
            hasher.combine(preferences)
        case .logOut:
            hasher.combine(self)
        }
    }
}
