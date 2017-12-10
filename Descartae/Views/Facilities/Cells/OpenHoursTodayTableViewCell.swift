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

class OpenHoursTodayTableViewCell: FacilityDetailsBaseTableViewCell {

    // MARK: Properties

    static let identifier = String(describing: OpenHoursTableViewCell.self)
    static let rowHeight: CGFloat = 91.5

    @IBOutlet weak var todayOpenHours: UILabel!

    weak var delegate: OpenHoursTodayTableViewCellDelegate?
    var indexPath: IndexPath!

    // MARK: Actions

    @IBAction func didTouchCollapseButton(_ sender: UIButton) {
        delegate?.didTouchCollapseButton(sender)
    }
}
