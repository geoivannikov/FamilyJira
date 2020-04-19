//
//  RealmServise.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/19/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func insert<T: Object>(_ object: T)
    func get<T: Object>() -> T?
    func delete<T: Object>(_ object: T)
}

final class RealmService: RealmServiceProtocol {
    private lazy var realm: Realm = {
         return try! Realm()
    }()
    
    func insert<T: Object>(_ object: T) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    func get<T: Object>() -> T? {
        return realm.objects(T.self).first
    }
    
    func delete<T: Object>(_ object: T) {
        try! realm.write {
            realm.delete(object)
        }
    }
}
