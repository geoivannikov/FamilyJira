//
//  UITextField+.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/17/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    func registerUpdate(bindedFunction: @escaping ((String) -> Void),
                        subscriptions: inout Set<AnyCancellable>) {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap {  _ in self.text }
            .sink(receiveValue: bindedFunction)
            .store(in: &subscriptions)
    }
}
