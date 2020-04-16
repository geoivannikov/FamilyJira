//
//  TaskView.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/15/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

class TaskView: BaseView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Some title"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
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
        let url = NSURL(string: link)! as URL
        if let data = NSData(contentsOf: url) {
            image.image = UIImage(data: data as Data)
        }
        return image
    }()
    
    private let creationDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Creation date:"
        return label
    }()
    
    private let creationDateValue: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "02.04.2020"
        label.textColor = .gray
        return label
    }()
    
    private let assignedBy: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Assigned by:"
        return label
    }()
    
    private let assignerPhoto: UIImageView = {
        let image = UIImageView()
        image.makeRounded(radius: 18)
        image.backgroundColor = .backgroundOpacityGrey
        let url = NSURL(string: link)! as URL
        if let data = NSData(contentsOf: url) {
            image.image = UIImage(data: data as Data)
        }
        return image
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonBlue
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Completeв", for: .normal)
        return button
    }()
    
    private let refuseTask: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonRed
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Refuse", for: .normal)
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
            stackView.spacing = 15
            stackView.backgroundColor = .red
            return stackView
        }()
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
        
        let hStackViewPriorityCreator: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 10
            return stackView
        }()
        
        [priority, priorityValue, createdBy, creatorPhoto].forEach {
            hStackViewPriorityCreator.addArrangedSubview($0)
        }
        priority.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        creatorPhoto.snp.makeConstraints { make in
            make.height.width.equalTo(36)
        }
        
        let hStackViewDateAssigner: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 10
            return stackView
        }()
        
        [creationDate,
         creationDateValue,
         assignedBy,
         assignerPhoto].forEach {
            hStackViewDateAssigner.addArrangedSubview($0)
        }
        creationDate.snp.makeConstraints { make in
            make.width.equalTo(110)
        }
        assignerPhoto.snp.makeConstraints { make in
            make.height.width.equalTo(36)
        }
        
        [titleLabel,
         descriptionLabel,
         hStackViewPriorityCreator,
         hStackViewDateAssigner].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-15)
                make.leading.equalToSuperview().offset(15)
            }
        }
        
        stackView.setCustomSpacing(20.0, after: descriptionLabel)
        
        addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(60)
            make.bottom.equalToSuperview().offset(-80)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        addSubview(refuseTask)
        refuseTask.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-80)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
}
