//
//  OpenHoursTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 04/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

class OpenHoursTableViewCell: FacilityDetailsBaseTableViewCell {

    // MARK: Properties

    static let identifier = String(describing: OpenHoursTableViewCell.self)
    static let estimatedRowHeight: CGFloat = 50
    static let topShrinkedRowHeight: CGFloat = 44
    static let bottomExtendedRowHeight: CGFloat = 68
    static let topShrinkedBottomExtendedRowHeight: CGFloat = 62

    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var openHours: UILabel!
    @IBOutlet weak var dayOfWeekTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var openHoursBottomConstraint: NSLayoutConstraint!

    let dayOfWeekFirstRowTopConstraint: CGFloat = 0
    let openHoursLastRowBottomConstraint: CGFloat = 24
    let dayOfWeekInitialTopConstraint: CGFloat = 6
    let openHoursInitialBottomConstraint: CGFloat = 6

    var openHour: DisposalFacility.OpenHour! {
        didSet {
            bindOpenHourData()
        }
    }

    // MARK: Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        dayOfWeekTopConstraint.constant = dayOfWeekInitialTopConstraint
        openHoursBottomConstraint.constant = openHoursInitialBottomConstraint
    }

    // MARK: Data binding

    func bindOpenHourData() {
        dayOfWeek.text = openHour.dayOfWeek.toString
        openHours.text = openHour.openHours
    }
}
