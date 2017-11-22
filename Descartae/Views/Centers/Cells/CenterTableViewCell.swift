//
//  CenterTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 22/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

class CenterTableViewCell: UITableViewCell {

    // MARK: Properties

    static let identifier = String(describing: CenterTableViewCell.self)

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distanceTo: UILabel!

    var centerData: CenterData! {
        didSet {
            setupCenter()
        }
    }

    // MARK: Setup

    func setupCenter() {
        name.text = centerData.name
        address.text = centerData.location.address
        distanceTo.text = "2KM"
    }

}
