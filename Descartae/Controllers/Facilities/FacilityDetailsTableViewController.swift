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
        case openHours(openHours: [DisposalFacility.OpenHour]), telephone(telephone: String), website(website: String), report

        func associatedValue() -> Any? {
            switch self {
            case .openHours(let openHours):
                return openHours as Any
            case .telephone(let telephone):
                return telephone as Any
            default:
                return nil
            }
        }
    }

    // MARK: Properties

    lazy var openHoursTodayCell: OpenHoursTodayTableViewCell = {
        guard let cell = OpenHoursTodayTableViewCell.instantiateFromNib() else {
            return OpenHoursTodayTableViewCell()
        }

        cell.delegate = self
        return cell
    }()

    var facility: DisposalFacility!
    var sections: [Section] = []
    var isOpenHoursCollapsed = true
    var shouldOpenHoursBeCollapsible: Bool {
        return facility.openHours.count > 1
    }

    lazy var openHoursIndexPaths: [IndexPath] = {
        let openHoursSection = sections[openHoursTodayCell.indexPath.section]

        guard let openHours = openHoursSection.associatedValue() as? [DisposalFacility.OpenHour] else {
            return []
        }

        var openHoursIndexPaths: [IndexPath] = []
        for index in openHours.indices {
            openHoursIndexPaths.append(IndexPath(row: index + 1, section: openHoursTodayCell.indexPath.section))
        }

        return openHoursIndexPaths
    }()

    var openHoursCollapseButtonTitle: String {
        return isOpenHoursCollapsed ? "Menos" : "Mais"
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        setupTableView()
        setupSections()
    }

    // MARK: Setup

    func setupTableView() {
        tableView.register(
            OpenHoursTableViewCell.nib,
            forCellReuseIdentifier: OpenHoursTableViewCell.identifier
        )
    }

    func setupSections() {
        if let openHours = facility.openHours as? [DisposalFacility.OpenHour], openHours.count > 0 {
            sections.append(.openHours(openHours: openHours))
        }

//        if let telephone = facility.telephone {
//            sections.append(.telephone(telephone: telephone))
//        }
//
//        if let website = facility.website {
//            sections.append(.website(website: website))
//        }

//        sections.append(.report)
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
            return isOpenHoursCollapsed ? 1 : openHours.count + 1
        case .telephone, .website, .report:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section {
        case .openHours where indexPath.row == 0:
            openHoursTodayCell.indexPath = indexPath
            return openHoursTodayCell
        case .openHours(let openHours):
            if let cell = tableView.dequeueReusableCell(withIdentifier: OpenHoursTableViewCell.identifier, for: indexPath) as? OpenHoursTableViewCell {
                cell.shouldShowSeparator = false

                if indexPath.row == 1 {
                    cell.dayOfWeekTopConstraint.constant = cell.dayOfWeekFirstRowTopConstraint
                }

                if openHours.count == indexPath.row {
                    cell.shouldShowSeparator = true
                    cell.openHoursBottomConstraint.constant = cell.openHoursLastRowBottomConstraint
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]

        switch section {
        case .openHours where indexPath.row == 0:
            return OpenHoursTodayTableViewCell.estimatedRowHeight
        case .openHours(let openHours):
            if indexPath.row == 1 {
                return OpenHoursTableViewCell.topShrinkedEstimatedRowHeight
            }

            if openHours.count == indexPath.row {
                return OpenHoursTableViewCell.bottomExtendedEstimatedRowHeight
            }

            return OpenHoursTableViewCell.estimatedRowHeight
        default:
            return 50
        }
    }

}

// MARK: OpenHoursTodayTableViewCellDelegate

extension FacilityDetailsTableViewController: OpenHoursTodayTableViewCellDelegate {

    func didTouchCollapseButton(_ button: UIButton) {
        button.setTitle(openHoursCollapseButtonTitle, for: .normal)
        isOpenHoursCollapsed = !isOpenHoursCollapsed

        if isOpenHoursCollapsed {
            tableView.deleteRows(at: openHoursIndexPaths, with: .automatic)
        } else {
            tableView.insertRows(at: openHoursIndexPaths, with: .automatic)
        }
    }

}
