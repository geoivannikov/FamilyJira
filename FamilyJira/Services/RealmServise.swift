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
    func update<T: Object>(objects: T)
    func delete<T: Object>(_ object: T)
    func deleteAll()
}

// swiftlint:disable force_try
final class RealmService: RealmServiceProtocol {
    private lazy var realm: Realm = {
         try! Realm()
    }()

    func insert<T: Object>(_ object: T) {
        try! realm.write {
            realm.add(object)
        }
    }

    func get<T: Object>() -> T? {
        realm.objects(T.self).first
    }

    func update<T: Object>(objects: T) {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self)
        try! realm.write {
            realm.delete(realmResults)
            realm.add(objects)
        }
    }

    func delete<T: Object>(_ object: T) {
        try! realm.write {
            realm.delete(object)
        }
    }

    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
