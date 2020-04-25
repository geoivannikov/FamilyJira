//
//  TaskViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/12/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

class TaskViewController: UIViewController {
    private var taskViewModel: TaskViewModelProtocol!
    private let taskView = TaskView()

    static func instantiate(taskViewModel: TaskViewModelProtocol) -> TaskViewController {
        let viewController: TaskViewController = TaskViewController()
        viewController.taskViewModel = taskViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        dismissKeyboardAfterTap()
    }

    private func setupLayout() {
        view.backgroundColor = .backgroundBlue

        view.addSubview(taskView)
        taskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
