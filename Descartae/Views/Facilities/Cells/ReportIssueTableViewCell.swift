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

    static let identifier = String(describing: ContactTableViewCell.self)
    static let rowHeight: CGFloat = 92

    weak var delegate: ReportIssueTableViewCellDelegate?

    // MARK: Actions

    @IBAction func reportAnIssue(_ sender: UIButton) {
        delegate?.didTouchReportIssueButton()
    }

}
