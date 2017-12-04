//
//  OpenHoursTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 04/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

class OpenHoursTableViewCell: UITableViewCell {

    // MARK: Properties

    static let identifier = String(describing: OpenHoursTableViewCell.self)
    static let estimatedRowHeight: CGFloat = 50
    static let bottomOrTopEstimatedRowHeight: CGFloat = 64

    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var openHours: UILabel!
    @IBOutlet weak var dayOfWeekTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var openHoursBottomConstraint: NSLayoutConstraint!

}
