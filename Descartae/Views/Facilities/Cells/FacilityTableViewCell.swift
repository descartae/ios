//
//  FacilityTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 22/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit
import SDWebImage

class FacilityTableViewCell: UITableViewCell {

    // MARK: Properties

    static let identifier = String(describing: FacilityTableViewCell.self)
    static let estimatedRowHeight: CGFloat = 114

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distanceTo: UILabel!

    var facility: Facility! {
        didSet {
            setupFacility()
        }
    }

    // MARK: Setup

    func setupFacility() {
        name.text = facility.name
        address.text = facility.location.address
        distanceTo.text = String(format: "%.2fKM", LocationManager.shared.distanceInKm(fromLocation: facility.location.location))
    }

}
