//
//  TodayTaskViewController.swift
//  TodayTasks
//
//  Created by George Ivannikov on 5/2/20.
//  Copyright © 2020 George Ivannikov. All rights reserved.
//

import UIKit
import SnapKit
import NotificationCenter

class TodayTaskViewController: UIViewController, NCWidgetProviding {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }

}
