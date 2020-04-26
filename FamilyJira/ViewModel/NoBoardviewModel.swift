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
    var joinBoardTapped: PassthroughSubject<Void, Never> { get }
    var createTapped: PassthroughSubject<BoardBasicInfoDTO?, Never> { get }
    var presentError: PassthroughSubject<CreateBoardError, Never> { get }
    var boardCreated: PassthroughSubject<Void, Never> { get }
}

final class NoBoardViewModel: NoBoardViewModelProtocol {
    let joinBoardTapped: PassthroughSubject<Void, Never>
    let createTapped: PassthroughSubject<BoardBasicInfoDTO?, Never>
    let presentError: PassthroughSubject<CreateBoardError, Never>
    let boardCreated: PassthroughSubject<Void, Never>

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

        joinBoardTapped = PassthroughSubject<Void, Never>()
        createTapped = PassthroughSubject<BoardBasicInfoDTO?, Never>()
        presentError = PassthroughSubject<CreateBoardError, Never>()
        boardCreated = PassthroughSubject<Void, Never>()

        createTapped
            .sink(receiveValue: createBoard(boardInfo:))
            .store(in: &subscriptions)
    }

    private func createBoard(boardInfo: BoardBasicInfoDTO?) {
        guard reachabilityService.isConnectedToNetwork() else {
            presentError.send(CreateBoardError.noConnection)
            return
        }
        guard let boardInfoDTO = boardInfo else {
            presentError.send(CreateBoardError.validationError)
            return
        }
        firebaseServise.createBoard(boardInfo: boardInfoDTO)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    self?.presentError.send(error)
                }
            }, receiveValue: { [weak self] boardInfo in
                guard let self = self,
                    let user: UserObject = self.realmService.get() else {
                    return
                }
                let board = BoardObject(model: boardInfo, user: user)
                self.realmService.insert(board)
                NotificationCenter.default.post(name: .boardUpdated, object: nil)
                self.boardCreated.send()
            })
            .store(in: &subscriptions)
    }
}
