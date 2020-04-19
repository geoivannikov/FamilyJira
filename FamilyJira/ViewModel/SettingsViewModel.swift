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
    var signOutTapped: PassthroughSubject<Void, Never> { get }
    var userSignedOut: PassthroughSubject<Void, Never> { get }
    var signOutFailed: PassthroughSubject<Void, Never> { get }

    func viewDidLoad()
}

final class SettingsViewModel: SettingsViewModelProtocol {
    let settingsData: PassthroughSubject<[[Settings]], Never>
    let editprofileTapped: PassthroughSubject<Void, Never>
    let signOutTapped: PassthroughSubject<Void, Never>
    let userSignedOut: PassthroughSubject<Void, Never>
    let signOutFailed: PassthroughSubject<Void, Never>

    private var subscriptions = Set<AnyCancellable>()
    
    init(
        firebaseService: FirebaseServiceProtocol = FamilyJiraDI.forceResolve()
    ) {
        settingsData = PassthroughSubject<[[Settings]], Never>()
        editprofileTapped = PassthroughSubject<Void, Never>()
        signOutTapped = PassthroughSubject<Void, Never>()
        userSignedOut = PassthroughSubject<Void, Never>()
        signOutFailed = PassthroughSubject<Void, Never>()
        
        signOutTapped
            .sink(receiveValue: { [weak self] _ in
                do {
                    try firebaseService.signOut()
                    self?.userSignedOut.send()
                } catch {
                    self?.signOutFailed.send()
                }
            })
            .store(in: &subscriptions)
    }
    
    func viewDidLoad() {
        settingsData.send([[.profile(ProfileSection(name: "George", role: "Son"))],
                           [.preferences(PreferencesSection(icon: UIImage.privacyIcon, title: "Privacy")),
                            .preferences(PreferencesSection(icon: UIImage.notificationsIcon, title: "Notifications")),
                            .preferences(PreferencesSection(icon: UIImage.soundsIcon, title: "Sounds")),
                            .preferences(PreferencesSection(icon: UIImage.licenseIcon, title: "License"))],
                           [.logOut]])
    }
}
