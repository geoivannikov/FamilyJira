//
//  HomeViewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol HomeViewModelProtocol {
    var isUserLoggedIn: PassthroughSubject<Bool, Never> { get }
    var presentRequestError: PassthroughSubject<RequestError, Never> { get }
    var user: PassthroughSubject<UserObject, Never> { get }

    func viewDidLoad()
}

final class HomeViewModel: HomeViewModelProtocol {
    let isUserLoggedIn: PassthroughSubject<Bool, Never>
    let presentRequestError: PassthroughSubject<RequestError, Never>
    let user: PassthroughSubject<UserObject, Never>
    
    private let firebaseServise: FirebaseServiceProtocol

    private var subscriptions = Set<AnyCancellable>()
    
    init(
        firebaseServise: FirebaseServiceProtocol = FamilyJiraDI.forceResolve(),
        reachabilityServis: ReachabilityServisProtocolol = FamilyJiraDI.forceResolve(),
        realmServise: RealmServiceProtocol = FamilyJiraDI.forceResolve()
    ) {
        self.firebaseServise = firebaseServise
        isUserLoggedIn = PassthroughSubject<Bool, Never>()
        presentRequestError = PassthroughSubject<RequestError, Never>()
        user = PassthroughSubject<UserObject, Never>()
        
        isUserLoggedIn
            .filter { $0 == true }
            .setFailureType(to: RequestError.self)
            .flatMap { _ -> AnyPublisher<UserDTO, RequestError> in
                if reachabilityServis.isConnectedToNetwork() {
                    return firebaseServise.requestUser()
                } else {
                    return Future<UserDTO, RequestError> {
                        $0(.failure(.noConnection))
                    }.eraseToAnyPublisher()
                }
            }
            .compactMap { UserObject(model: $0) }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    self?.presentRequestError.send(error)
                    if let user: UserObject = realmServise.get() {
                        self?.user.send(user)
                    }
                }
            }, receiveValue: { [weak self] user in
                realmServise.insert(user)
                self?.user.send(user)
            })
            .store(in: &subscriptions)
    }
    
    func viewDidLoad() {
        isUserLoggedIn.send(firebaseServise.isUserLoggedIn)
    }
}
