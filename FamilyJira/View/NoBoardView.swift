//
//  NoBoardView.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/16/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class NoBoardView: BaseView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        label.text = "You are not a member of any board"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()

    let createButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonBlue
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Create the board", for: .normal)
        return button
    }()

    let joinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonGrey
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitle("Join the board", for: .normal)
        return button
    }()

    override func setupView() {
        let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            return scrollView
        }()

        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 10
            return stackView
        }()

        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
        }

        stackView.addArrangedSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
        }
        stackView.setCustomSpacing(25.0, after: messageLabel)

        [createButton, joinButton].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(175)
            }
        }
    }
}
