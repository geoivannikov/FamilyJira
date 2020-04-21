//
//  ProfileCell.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/11/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class ProfileCell: UITableViewCell {
    private let profilePhoto: UIImageView = {
        let image = UIImageView()
        image.makeRounded(radius: 40)
        image.backgroundColor = .backgroundOpacityGrey
        return image
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
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
    }
    
    func setupCell(model: ProfileSection) {
        nameLabel.text = model.username
        roleLabel.text = model.role
        if let data = model.photoData {
            profilePhoto.image = UIImage(data: data as Data)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
