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

    lazy var openHoursTodayCell: OpenHoursTodayTableViewCell = {
        let cell = OpenHoursTodayTableViewCell()
        cell.delegate = self
        return cell
    }()

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

    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.register(OpenHoursTableViewCell.nib, forCellReuseIdentifier: OpenHoursTableViewCell.identifier)
    }

    func setupSections() {
        if let openHours = facility.openHours as? [Facility.OpenHour], openHours.count > 0 {
            sections.append(.openHours(openHours: openHours))
        }

//        if let telephone = facility.telephone {
//            sections.append(.telephone(telephone: telephone))
//        }
//
//        if let website = facility.website {
//            sections.append(.website(website: website))
//        }

        sections.append(.report)
    }

}

// MARK: UITableViewDataSource

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section {
        case .openHours where indexPath.row == 0:
            return openHoursTodayCell
        case .openHours(let openHours):
            if let cell = tableView.dequeueReusableCell(withIdentifier: OpenHoursTableViewCell.identifier, for: indexPath) as? OpenHoursTableViewCell {
                if indexPath.row == 0 {
                    cell.dayOfWeekTopConstraint.constant = 20
                }

                if openHours.count == indexPath.row - 1 {
                    cell.openHoursBottomConstraint.constant = 20
                }

                return cell
            }

            return UITableViewCell()
        default:
            break
        }

        return UITableViewCell()
    }

}

// MARK: UITableViewDelegate

extension FacilityDetailsTableViewController {

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]

        switch section {
        case .openHours where indexPath.row == 0:
            return OpenHoursTodayTableViewCell.estimatedRowHeight
        case .openHours(let openHours):
            return indexPath.row == 0 || openHours.count == indexPath.row - 1 ?
                    OpenHoursTableViewCell.bottomOrTopEstimatedRowHeight : OpenHoursTableViewCell.estimatedRowHeight
        default:
            return 50
        }
    }

}

// MARK: OpenHoursTodayTableViewCellDelegate

extension FacilityDetailsTableViewController: OpenHoursTodayTableViewCellDelegate {

    func didTouchCollapseButton(_ button: UIButton) {

    }

}
