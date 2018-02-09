//
//  UnavailableRegionViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 29/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class UnavailableRegionViewController: UIViewController {

    // MARK: Properties

    static let identifier = String(describing: UnavailableRegionViewController.self)

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reportAnIssueNav = segue.destination as? ReportAnIssueNavigationController,
            let reportAnIssue = reportAnIssueNav.childViewControllers[0] as? ReportAnIssueTableViewController {
            reportAnIssue.inputType = .regionWaitlist
        }
    }

}
