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
    var user: PassthroughSubject<UserObject, Never> { get }

    func requestUser()
}

final class SettingsViewModel: SettingsViewModelProtocol {
    let settingsData: PassthroughSubject<[[Settings]], Never>
    let editprofileTapped: PassthroughSubject<Void, Never>
    let signOutTapped: PassthroughSubject<Void, Never>
    let userSignedOut: PassthroughSubject<Void, Never>
    let signOutFailed: PassthroughSubject<Void, Never>
    let user: PassthroughSubject<UserObject, Never>

    private let firebaseServise: FirebaseServiceProtocol
    private let reachabilityService: ReachabilityServisProtocolol
    private let realmService: RealmServiceProtocol

    private var subscriptions = Set<AnyCancellable>()

    init(
        firebaseServise: FirebaseServiceProtocol = FamilyJiraDI.forceResolve(),
        reachabilityService: ReachabilityServisProtocolol = FamilyJiraDI.forceResolve(),
        realmService: RealmServiceProtocol = FamilyJiraDI.forceResolve()
    ) {
        self.firebaseServise = firebaseServise
        self.reachabilityService = reachabilityService
        self.realmService = realmService
        settingsData = PassthroughSubject<[[Settings]], Never>()
        editprofileTapped = PassthroughSubject<Void, Never>()
        signOutTapped = PassthroughSubject<Void, Never>()
        userSignedOut = PassthroughSubject<Void, Never>()
        signOutFailed = PassthroughSubject<Void, Never>()
        user = PassthroughSubject<UserObject, Never>()

        signOutTapped
            .sink(receiveValue: { [weak self] _ in
                do {
                    try firebaseServise.signOut()
                    realmService.deleteAll()
                    self?.userSignedOut.send()
                } catch {
                    self?.signOutFailed.send()
                }
            })
            .store(in: &subscriptions)

        user
            .map {
                [[Settings.profile(ProfileSection(username: $0.username, role: $0.role, photoData: $0.photoData))],
                [Settings.preferences(PreferencesSection(icon: UIImage.privacyIcon, title: "Privacy")),
                 Settings.preferences(PreferencesSection(icon: UIImage.notificationsIcon, title: "Notifications")),
                 Settings.preferences(PreferencesSection(icon: UIImage.soundsIcon, title: "Sounds")),
                 Settings.preferences(PreferencesSection(icon: UIImage.licenseIcon, title: "License"))],
                [Settings.logOut]]
            }
            .sink(receiveValue: { [weak self] in
                self?.settingsData.send($0)
            })
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: .userUpdated, object: nil)
            .sink(receiveValue: { [weak self] _ in
                guard let user: UserObject = realmService.get() else {
                    return
                }
                self?.user.send(user)
            })
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: .userLoggedIn, object: nil)
            .sink(receiveValue: { [weak self] _ in
                self?.requestUser()
            })
            .store(in: &subscriptions)
    }

    func requestUser() {
        guard reachabilityService.isConnectedToNetwork() else {
            if let userObject: UserObject = realmService.get() {
                user.send(userObject)
            }
            return
        }

        firebaseServise.requestUser()
            .compactMap { UserObject(model: $0) }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    ()
                case .failure:
                    if let userObject: UserObject = self?.realmService.get() {
                        self?.user.send(userObject)
                    }
                }
            }, receiveValue: { [weak self] user in
                self?.realmService.insert(user)
                self?.user.send(user)
            })
            .store(in: &subscriptions)
    }
}
