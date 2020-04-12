//
//  SettingsViewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/11/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol SettingsViewModelProtocol {
    var settingsData: PassthroughSubject<[[Settings]], Never> { get }
    var editprofileTapped: PassthroughSubject<Void, Never> { get }
    func settingsOpened()
}

final class SettingsViewModel: SettingsViewModelProtocol {
    let settingsData: PassthroughSubject<[[Settings]], Never>
    let editprofileTapped: PassthroughSubject<Void, Never>
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        firebaseService: FirebaseServiceProtocol = FamilyJiraDI.forceResolve()
    ) {
        settingsData = PassthroughSubject<[[Settings]], Never>()
        editprofileTapped = PassthroughSubject<Void, Never>()
    }
    
    func settingsOpened() {
        settingsData.send([[.profile(ProfileSection(name: "George", role: "Son"))],
                           [.preferences(PreferencesSection(icon: UIImage.privacyIcon, title: "Privacy")),
                            .preferences(PreferencesSection(icon: UIImage.notificationsIcon, title: "Notifications")),
                            .preferences(PreferencesSection(icon: UIImage.soundsIcon, title: "Sounds")),
                            .preferences(PreferencesSection(icon: UIImage.licenseIcon, title: "License"))],
                           [.logOut]])
    }
}
