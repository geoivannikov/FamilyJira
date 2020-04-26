//
//  ProfileView.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class ProfileView: BaseView {
    let profilePhoto: UIImageView = {
        let image = UIImageView()
        image.makeRounded(radius: 80)
        image.backgroundColor = .backgroundOpacityGrey
        image.contentMode = .scaleAspectFill
        return image
    }()

    let chooseButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.buttonBlue.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Choose", for: .normal)
        button.setTitleColor(.buttonBlue, for: .normal)
        return button
    }()

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Username"
        return textField
    }()

    let roleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Role"
        return textField
    }()

    override func setupView() {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 10
            return stackView
        }()

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(120)
        }
        stackView.addArrangedSubview(profilePhoto)
        profilePhoto.snp.makeConstraints { make in
            make.width.height.equalTo(160)
        }
        stackView.addArrangedSubview(chooseButton)
        chooseButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        [usernameTextField, roleTextField].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-30)
                make.leading.equalToSuperview().offset(30)
            }
        }
        stackView.setCustomSpacing(30.0, after: chooseButton)
    }
}
