//
//  NoBoardViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/16/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class NoBoardViewController: UIViewController {
    private let noBoardView = NoBoardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    private func setUpLayout() {
        view.backgroundColor = .backgroundBlue
        
        view.addSubview(noBoardView)
        noBoardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
