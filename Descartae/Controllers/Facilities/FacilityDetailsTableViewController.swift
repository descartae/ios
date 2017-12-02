//
//  FacilityDetailsTableViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 02/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

class FacilityDetailsTableViewController: UITableViewController {

    // MARK: Nested types

    enum Section {
        case openHours, telephone, website, report
    }

    // MARK: Properties

    var facility: Facility!
    var sections: [Section] = []

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
