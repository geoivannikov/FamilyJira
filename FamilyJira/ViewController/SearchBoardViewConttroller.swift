//
//  SearchBoardViewConttroller.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/25/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit
import Combine

class SearchBoardViewController: UITableViewController {
    private var searchBoardViewModel: SearchBoardViewModelProtocol!
    private let searchController = UISearchController(searchResultsController: nil)

    static func instantiate(
        searchBoardViewModel: SearchBoardViewModelProtocol
    ) -> SearchBoardViewController {
        let viewController: SearchBoardViewController = SearchBoardViewController()
        viewController.searchBoardViewModel = searchBoardViewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        dismissKeyboardAfterTap()
    }

    private func setUpLayout() {
        view.backgroundColor = .backgroundBlue
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)

        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .backgroundBlue
        searchController.searchBar.backgroundColor = .backgroundBlue
        searchController.searchBar.barStyle = .default

        tableView.backgroundColor = .backgroundBlue
        tableView.backgroundView = UIView()
        tableView.tableHeaderView = searchController.searchBar
        tableView.separatorStyle = .none

        let clearImage = UIImage.from(color: UIColor.clear)
        searchController.searchBar.setBackgroundImage(clearImage, for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        searchController.searchBar.backgroundColor = .backgroundBlue
        searchController.searchBar.tintColor = UIColor.white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
    }
}

extension SearchBoardViewController: UISearchControllerDelegate {
}

extension SearchBoardViewController: UISearchBarDelegate {
}
