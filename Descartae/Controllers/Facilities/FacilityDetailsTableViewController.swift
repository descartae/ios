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
        case openHours(openHours: [Facility.OpenHour]), telephone(telephone: String), website(website: String), report
    }

    // MARK: Properties

    var facility: Facility!
    var sections: [Section] = []
    var isOpenHoursCollapsed = false
    var shouldOpenHoursBeCollapsible: Bool {
        let openHoursCount = facility.openHours?.count ?? 0
        return openHoursCount > 1
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSections()
    }

    // MARK: Setup

    func setupSections() {
        if let openHours = facility.openHours as? [Facility.OpenHour], openHours.count > 0 {
            sections.append(.openHours(openHours: openHours))
        }

        if let telephone = facility.telephone {
            sections.append(.telephone(telephone: telephone))
        }

        if let website = facility.website {
            sections.append(.website(website: website))
        }

        sections.append(.report)
    }

}

extension FacilityDetailsTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let facilitySection = sections[section]

        switch facilitySection {
        case .openHours(let openHours):
            return isOpenHoursCollapsed ? 1 : openHours.count
        case .telephone, .website, .report:
            return 1
        }
    }

}
