//
//  SettingsCell.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/11/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class SettingsCell: UITableViewCell {
    private let profilePhoto: UIImageView = {
        let image = UIImageView()
        image.makeRounded(radius: 40)
        image.backgroundColor = .backgroundOpacityGrey
        return image
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let icon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "sdffds"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    private func setupProfileLayout() {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 20
            return stackView
        }()
        
        let textInfoStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            return stackView
        }()
        
        addSubview(stackView)
        [profilePhoto, textInfoStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        [nameLabel, roleLabel].forEach {
            textInfoStackView.addArrangedSubview($0)
        }
        stackView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        textInfoStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
        }
        profilePhoto.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        accessoryType = .disclosureIndicator
    }
    
    private func setupSettingsLayout() {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 20
            return stackView
        }()

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        [icon, titleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        accessoryType = .disclosureIndicator
    }
    
    private func setupLogOutLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        titleLabel.text = "Log out"
        titleLabel.textColor = .red
        titleLabel.textAlignment = .center
    }
    
    func setupCell(model: Settings) {
        switch model {
        case .profile(let profileSection):
            setupProfileLayout()
            nameLabel.text = profileSection.name
            roleLabel.text = profileSection.role
            if let data = profileSection.photoData {
                profilePhoto.image = UIImage(data: data as Data)
            }
        case .preferences(let settingsSection):
            titleLabel.text = settingsSection.title
            icon.image = settingsSection.icon
            setupSettingsLayout()
        case .logOut:
            setupLogOutLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
