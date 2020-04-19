//
//  FamilyJiraDI.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/11/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import Swinject

final class FamilyJiraDI: NSObject {
    static var container = Container()
    
    static func start() {
        FamilyJiraDI.container.register(FirebaseServiceProtocol.self) { _ in
            FirebaseService()
        }.inObjectScope(.transient)
        
        FamilyJiraDI.container.register(ReachabilityServisProtocolol.self) { _ in
            ReachabilityServis()
        }.inObjectScope(.transient)
        
        FamilyJiraDI.container.register(RealmServiceProtocol.self) { _ in
            RealmService()
        }.inObjectScope(.transient)
    }
    
    static func forceResolve<T>() -> T {
        return container.resolve(T.self)!
    }
}
