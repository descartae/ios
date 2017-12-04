//
//  OpenHoursTodayTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 03/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

protocol OpenHoursTodayTableViewCellDelegate: class {
    func didTouchCollapseButton(_ button: UIButton)
}

class OpenHoursTodayTableViewCell: UITableViewCell {

    // MARK: Properties

    static let identifier = String(describing: OpenHoursTableViewCell.self)
    static let estimatedRowHeight: CGFloat = 92

    @IBOutlet weak var todayOpenHours: UILabel!

    weak var delegate: OpenHoursTodayTableViewCellDelegate?

    // MARK: Actions

    @IBAction func didTouchCollapseButton(_ sender: UIButton) {
        delegate?.didTouchCollapseButton(sender)
    }
}
