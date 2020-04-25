//
//  MyTasksViewModel.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Combine

protocol MyTasksViewModelProtocol {
    var myTasksData: PassthroughSubject<[[Task]], Never> { get }
    var taskSelected: PassthroughSubject<Void, Never> { get }
    func myTasksOpened()
}

final class MyTasksViewModel: MyTasksViewModelProtocol {
    let myTasksData: PassthroughSubject<[[Task]], Never>
    let taskSelected: PassthroughSubject<Void, Never>

    init(
        firebaseService: FirebaseServiceProtocol = FamilyJiraDI.forceResolve()
    ) {
        myTasksData = PassthroughSubject<[[Task]], Never>()
        taskSelected = PassthroughSubject<Void, Never>()
    }

    func myTasksOpened() {
        myTasksData.send([[Task(), Task()]])
    }
}
