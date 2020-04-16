//
//  TaskCell.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Some title"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private let taskDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        return label
    }()
    
    private let priority: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Priority:"
        return label
    }()
    
    private let priorityValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "High"
        label.textColor = .red
        return label
    }()
    
    private let createdBy: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Ceated by:"
        return label
    }()
    
    private let creatorPhoto: UIImageView = {
        let image = UIImageView()
        image.makeRounded(radius: 18)
        image.backgroundColor = .backgroundOpacityGrey
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    private func setUpLayout() {
        backgroundColor = .none
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        contentView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        
        let vStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.spacing = 10
            return stackView
        }()

        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        let hStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 10
            return stackView
        }()
        
        [priority, priorityValue, createdBy, creatorPhoto].forEach {
            hStackView.addArrangedSubview($0)
        }
        priority.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        creatorPhoto.snp.makeConstraints { make in
            make.height.width.equalTo(36)
        }
        
        [title, taskDescription, hStackView].forEach {
            vStackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(10)
                make.trailing.equalToSuperview().offset(-10)
            }
        }
        vStackView.setCustomSpacing(20.0, after: taskDescription)
    }
    
    func setupCell(model: Task) {
        let url = NSURL(string: link)! as URL
        if let data = NSData(contentsOf: url) {
            creatorPhoto.image = UIImage(data: data as Data)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
