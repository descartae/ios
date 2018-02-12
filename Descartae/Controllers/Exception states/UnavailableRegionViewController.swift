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


    @IBOutlet weak var unavailableRegionTitle: UILabel! {
        didSet {
            unavailableRegionTitle.text = localized("unavailable_region_title")
        }
    }

    @IBOutlet weak var unavailableRegionSubtitle: UILabel! {
        didSet {
            unavailableRegionSubtitle.text = localized("unavailable_region_subtitle")
        }
    }

    @IBOutlet weak var waitlistButton: UIButton! {
        didSet {
            waitlistButton.setTitle(localized("waitlist_button_title"), for: .normal)
        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reportAnIssueNav = segue.destination as? ReportAnIssueNavigationController,
            let reportAnIssue = reportAnIssueNav.childViewControllers[0] as? ReportAnIssueTableViewController {
            reportAnIssue.inputType = .regionWaitlist
        }
    }

}
