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
    private let profilePhoto: UIImageView = {
        let image = UIImageView()
        image.makeRounded(radius: 80)
        image.backgroundColor = .backgroundOpacityGrey
        return image
    }()
    
    let chooseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonBlue
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Choose", for: .normal)
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Name"
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
            make.top.equalToSuperview().offset(90)
        }
        stackView.addArrangedSubview(profilePhoto)
        profilePhoto.snp.makeConstraints { make in
            make.width.height.equalTo(160)
        }
        stackView.addArrangedSubview(chooseButton)
        chooseButton.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
        [nameTextField, roleTextField].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-30)
                make.leading.equalToSuperview().offset(30)
            }
        }
        stackView.setCustomSpacing(30.0, after: chooseButton)
        
        setUp()
    }
    
    private func setUp() {
        let url = NSURL(string: link)! as URL
        if let data = NSData(contentsOf: url) {
            profilePhoto.image = UIImage(data: data as Data)
        }
    }
}
