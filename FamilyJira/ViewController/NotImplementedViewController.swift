//
//  NotImplementedViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class NotImplementedViewController: UIViewController {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Not implemented"
        label.textAlignment = .center
        label.textColor = .backgroundOpacityGrey
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .backgroundBlue

        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
}
