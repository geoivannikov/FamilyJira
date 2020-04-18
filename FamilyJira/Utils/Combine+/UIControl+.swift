//
//  UIControl+.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/17/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

extension UIControl: CombineCompatible { }

extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> UIControlPublisher<UIControl> {
        UIControlPublisher(control: self, events: events)
    }
}
