//
//  ProfileViewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol ProfileViewModelProtocol {
    var user: PassthroughSubject<UserObject, Never> { get }
    var choosenPhoto: PassthroughSubject<UIImage?, Never> { get }
    var doneTapped: PassthroughSubject<ProfileDTO?, Never> { get }
    var presentError: PassthroughSubject<UpdateProfileError, Never> { get }

    func viewDidLoad()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    let user: PassthroughSubject<UserObject, Never>
    let choosenPhoto: PassthroughSubject<UIImage?, Never>
    let doneTapped: PassthroughSubject<ProfileDTO?, Never>
    let presentError: PassthroughSubject<UpdateProfileError, Never>
    
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
        user = PassthroughSubject<UserObject, Never>()
        choosenPhoto = PassthroughSubject<UIImage?, Never>()
        doneTapped = PassthroughSubject<ProfileDTO?, Never>()
        presentError = PassthroughSubject<UpdateProfileError, Never>()
        
        doneTapped
            .sink(receiveValue: updateProfile(profile:))
            .store(in: &subscriptions)
    }
    
    func viewDidLoad() {
        if let userObject: UserObject = realmService.get() {
            user.send(userObject)
        }
    }
    
    func updateProfile(profile: ProfileDTO?) {
        guard reachabilityService.isConnectedToNetwork() else {
            presentError.send(UpdateProfileError.noConnection)
            return
        }
        guard let profileDTO = profile else {
            presentError.send(UpdateProfileError.validationError)
            return
        }
        firebaseServise.updateProfile(profileDTO: profileDTO)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    self?.presentError.send(error)
                }
            }, receiveValue: { [weak self] profile in
                guard let user: UserObject = self?.realmService.get() else {
                    return
                }
                let updatedUser = UserObject(user: user, profile: profile)
                self?.realmService.update(objects: updatedUser)
                NotificationCenter.default.post(name: .userUpdated, object: nil)
            })
            .store(in: &subscriptions)
    }
}
