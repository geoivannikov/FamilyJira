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

    func viewDidLoad()
}

final class HomeViewModel: HomeViewModelProtocol {
    let isUserLoggedIn: PassthroughSubject<Bool, Never>
    
    private let firebaseServise: FirebaseServiceProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        firebaseServise: FirebaseServiceProtocol = FamilyJiraDI.forceResolve()
    ) {
        self.firebaseServise = firebaseServise
        isUserLoggedIn = PassthroughSubject<Bool, Never>()
    }
    
    func viewDidLoad() {
        print("viewDidLoad firebaseServise.isUserLoggedIn")
        isUserLoggedIn.send(firebaseServise.isUserLoggedIn)
    }
}
