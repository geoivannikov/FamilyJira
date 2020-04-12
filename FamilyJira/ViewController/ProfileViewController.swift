//
//  ProfileViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

class ProfileViewController: UIViewController {
    private var profileViewModel: ProfileViewModelProtocol!
    private var profileView = ProfileView()
    private var doneButton: UIBarButtonItem {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
        button.isEnabled = false
        return button
    }
    
    static func instantiate(profileViewModel: ProfileViewModelProtocol) -> ProfileViewController {
        let viewController: ProfileViewController = ProfileViewController()
        viewController.profileViewModel = profileViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        dismissKeyboardAfterTap()
    }
    
    private func setupLayout() {
        title = "Profile"
        view.backgroundColor = .backgroundBlue
        
        navigationItem.rightBarButtonItem = doneButton
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.trailing.leading.bottom.top.equalToSuperview()
        }
    }
}
