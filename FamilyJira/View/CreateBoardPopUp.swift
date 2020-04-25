//
//  CreateBoardPopUp.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/25/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class CreateBoardPopUp: BaseView {
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.text = "New board"
        label.textAlignment = .center
        return label
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Family name"
        return textField
    }()

    let profilePhoto: UIImageView = {
        let image = UIImageView()
        image.makeRounded(radius: 80)
        image.backgroundColor = .backgroundOpacityGrey
        return image
    }()

    let chooseButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.buttonBlue.cgColor
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true
        button.setTitle("Choose", for: .normal)
        button.setTitleColor(.buttonBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()

    let createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonBlue
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Create", for: .normal)
        return button
    }()

    override func setupView() {
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                           nameTextField,
                                                           profilePhoto,
                                                           chooseButton,
                                                           createButton])
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            return stackView
        }()

        backgroundColor = .backgroundOpacityGrey
        alpha = 0

        addSubview(container)
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(400)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)

        container.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        nameTextField.snp.makeConstraints { make in
            make.width.equalTo(240)
        }
        profilePhoto.snp.makeConstraints { make in
            make.height.width.equalTo(160)
        }
        chooseButton.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        createButton.snp.makeConstraints { make in
            make.width.equalTo(200)
        }

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
    }

    @objc fileprivate func animateOut() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn,
                       animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        })
    }

    @objc func animateIn() {
        container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        alpha = 1
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseIn,
                       animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.container.transform = .identity
        })
    }
}
