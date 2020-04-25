//
//  UISearchController+.swift
//  FamilyJira
//
//  Created by George Ivannikov on 4/25/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import Foundation
import UIKit

extension UISearchController {
    func configureSearchBar(searchBarText: String,
                            tintColor: UIColor,
                            backgroundColor: UIColor,
                            textFieldColor: UIColor,
                            borderColor: UIColor) {
        let clearImage = UIImage.from(color: UIColor.clear)
        searchBar.setBackgroundImage(clearImage, for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        searchBar.backgroundColor = backgroundColor
        searchBar.tintColor = UIColor.white
    }

    func configureSearchBar(searchBarText: String) {
        configureSearchBar(searchBarText: searchBarText,
                           tintColor: .backgroundOpacityGrey,
                           backgroundColor: .white,
                           textFieldColor: .white,
                           borderColor: .gray)
    }
}
