//
//  MyTasksViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit
import Combine
import CombineDataSources

class MyTasksViewController: UITableViewController {
    private var myTasksViewModel: MyTasksViewModelProtocol!

    private var subscriptions = Set<AnyCancellable>()

    private let segmentControl: UISegmentedControl = {
        let segmentControlItems = ["To do", "Completed"]
        let segmentControl = UISegmentedControl(items: segmentControlItems)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()

    static func instantiate(myTasksViewModel: MyTasksViewModelProtocol) -> MyTasksViewController {
        let viewController: MyTasksViewController = MyTasksViewController()
        viewController.myTasksViewModel = myTasksViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setUpBinds()
        myTasksViewModel.myTasksOpened()
    }

    private func setupLayout() {
        navigationItem.titleView = segmentControl
        tableView.backgroundColor = .backgroundBlue
        tableView.separatorStyle = .none

        tableView.register(TaskCell.self, forCellReuseIdentifier: "MyTaskCell")
    }

    private func setUpBinds() {
        myTasksViewModel.myTasksData
            .map { sections in
                sections.map { task -> Section<Task> in
                    Section(items: task)
                }
            }
            .bind(subscriber: tableView.sectionsSubscriber(cellIdentifier: "MyTaskCell",
                                                           cellType: TaskCell.self,
                                                           cellConfig: { cell, _, model in
                cell.setupCell(model: model)
            }))
            .store(in: &subscriptions)
    }
}

extension MyTasksViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTasksViewModel.taskSelected.send()
    }
}
