//
//  SettingsViewController.swift
//  FamilyJira
//
//  Created by George Ivannikov on 2/22/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit
import Combine
import CombineDataSources

class SettingsViewController: UITableViewController {
    private var settingsViewModel: SettingsViewModelProtocol!
    
    private var subscriptions = Set<AnyCancellable>()
    
    static func instantiate(settingsViewModel: SettingsViewModelProtocol) -> SettingsViewController {
        let viewController: SettingsViewController = SettingsViewController()
        viewController.settingsViewModel = settingsViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpBinds()
        
        settingsViewModel.settingsOpened()
    }
    
    private func setUpLayout() {
        title = "Settings"
        
        tableView.backgroundColor = .backgroundBlue
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.bounces = false

        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    private func setUpBinds() {
        settingsViewModel.settingsData
            .map { sections in
                sections.map { settings -> Section<Settings> in
                    Section(header: "Profile", items: settings)
                }
            }
            .bind(subscriber: tableView.sectionsSubscriber(cellIdentifier: "SettingsCell",
                                                           cellType: SettingsCell.self,
                                                           cellConfig: { cell, indexPath, model in
                cell.setupCell(model: model)
            }))
            .store(in: &subscriptions)
    }
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            settingsViewModel.editprofileTapped.send()
        } else {
            navigationController?.pushViewController(NotImplementedViewController(), animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.bounds.size.width,
                                              height: section == 0 ? 35 : 110))
        headerView.backgroundColor = .backgroundBlue
        let label = UILabel()
        label.frame = CGRect.init(x: 10,
                                  y: 5,
                                  width: headerView.frame.width - 10,
                                  height: headerView.frame.height - 10)
        if section == 0 {
            label.text = "Profile"
        } else if section == 1 {
            label.text = "Preferences"
        }
        label.font = UIFont.boldSystemFont(ofSize: 16)

        headerView.addSubview(label)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else if section == 1 {
            return 68
        } else {
            return 100
        }
    }
}
