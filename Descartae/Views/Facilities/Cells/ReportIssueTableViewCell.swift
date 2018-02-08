//
//  ReportIssueTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 11/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

protocol ReportIssueTableViewCellDelegate: class {
    func didTouchReportIssueButton()
}

class ReportIssueTableViewCell: UITableViewCell {

    // MARK: Properties

    static let identifier = String(describing: ReportIssueTableViewCell.self)
    static let rowHeight: CGFloat = 92

    @IBOutlet weak var reportAnIssueButton: UIButton! {
        didSet {
            reportAnIssueButton.setTitle(localized("report_an_issue_button_title"), for: .normal)
        }
    }

    weak var delegate: ReportIssueTableViewCellDelegate?

    // MARK: Actions

    @IBAction func reportAnIssue(_ sender: UIButton) {
        delegate?.didTouchReportIssueButton()
    }

}
