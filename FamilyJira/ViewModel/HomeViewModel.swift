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
    var board: PassthroughSubject<BoardObject, Never> { get }
    var doesUserHaveBoard: PassthroughSubject<Bool, Never> { get }

    func viewDidLoad()
}

final class HomeViewModel: HomeViewModelProtocol {
    let isUserLoggedIn: PassthroughSubject<Bool, Never>
    let presentRequestError: PassthroughSubject<RequestError, Never>
    let user: PassthroughSubject<UserObject, Never>
    let board: PassthroughSubject<BoardObject, Never>
    let doesUserHaveBoard: PassthroughSubject<Bool, Never>

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
        isUserLoggedIn = PassthroughSubject<Bool, Never>()
        presentRequestError = PassthroughSubject<RequestError, Never>()
        user = PassthroughSubject<UserObject, Never>()
        board = PassthroughSubject<BoardObject, Never>()
        doesUserHaveBoard = PassthroughSubject<Bool, Never>()

        isUserLoggedIn
            .filter { $0 == true }
            .sink(receiveValue: { [weak self] _ in
                self?.requestData()
            })
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: .userLoggedIn, object: nil)
            .sink(receiveValue: { [weak self] _ in
                self?.isUserLoggedIn.send(true)
            })
            .store(in: &subscriptions)

        user
            .map { $0.boardId != nil }
            .sink(receiveValue: { [weak self] in
                self?.doesUserHaveBoard.send($0)
            })
            .store(in: &subscriptions)

        doesUserHaveBoard
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                guard let boardObject: BoardObject = realmService.get() else {
                    return
                }
                self?.board.send(boardObject)
            })
            .store(in: &subscriptions)

        NotificationCenter.default.publisher(for: .boardUpdated, object: nil)
            .sink(receiveValue: { [weak self] _ in
                self?.requestData()
            })
            .store(in: &subscriptions)
    }

    func viewDidLoad() {
        isUserLoggedIn.send(firebaseServise.isUserLoggedIn)
    }

    private func requestData() {
        guard reachabilityService.isConnectedToNetwork() else {
            presentRequestError.send(.noConnection)
            if let userObject: UserObject = realmService.get() {
                presentRequestError.send(.noConnection)
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
                case .failure(let error):
                    self?.presentRequestError.send(error)
                    if let userObject: UserObject = self?.realmService.get() {
                        self?.user.send(userObject)
                    }
                }
            }, receiveValue: { [weak self] user in
                self?.realmService.update(objects: user)
                self?.user.send(user)
            })
            .store(in: &subscriptions)
    }
}
