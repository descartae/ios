//
//  FacilityDetailsTableViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 02/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit
import SafariServices

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

        cell.todayOpenHours.text = facility.openHoursForToday
        cell.delegate = self
        return cell
    }()

    lazy var telephoneCell: ContactTableViewCell = {
        guard let cell = ContactTableViewCell.instantiateFromNib() else {
            return ContactTableViewCell()
        }

        cell.contactType.text = "Contato"
        cell.contactActionButton.setTitle("Ligar", for: .normal)
        cell.delegate = self
        return cell
    }()

    lazy var websiteCell: ContactTableViewCell = {
        guard let cell = ContactTableViewCell.instantiateFromNib() else {
            return ContactTableViewCell()
        }

        cell.contactType.text = "Site"
        cell.contactActionButton.setTitle("Acessar", for: .normal)
        cell.delegate = self
        return cell
    }()

    lazy var reportAnIssueCell: ReportIssueTableViewCell = {
        guard let cell = ReportIssueTableViewCell.instantiateFromNib() else {
            return ReportIssueTableViewCell()
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
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0

        tableView.register(
            OpenHoursTableViewCell.nib,
            forCellReuseIdentifier: OpenHoursTableViewCell.identifier
        )

        tableView.register(
            ContactTableViewCell.nib,
            forCellReuseIdentifier: ContactTableViewCell.identifier
        )

        tableView.register(
            ReportIssueTableViewCell.nib,
            forCellReuseIdentifier: ReportIssueTableViewCell.identifier
        )
    }

    func setupSections() {
        if let openHours = facility.openHours as? [DisposalFacility.OpenHour], openHours.count > 0 {
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

    // MARK: Actions

    func call(telephone: String) {
        let telephoneWithoutWhiteSpaces = telephone.replacingOccurrences(of: " ", with: "")

        guard let url = URL(string: "tel://\(telephoneWithoutWhiteSpaces)"), UIApplication.shared.canOpenURL(url) else {
            return
        }

        UIApplication.shared.open(url)
    }

    func goTo(website: String) {
        guard let url = URL(string: website) else {
            return
        }

        let alertController = UIAlertController(title: website, message: "Deseja acessar este site?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let accessAction = UIAlertAction(title: "Acessar", style: .default) {  _ in
            let safari = SFSafariViewController(url: url)
            safari.modalPresentationStyle = .popover

            self.present(safari, animated: true, completion: nil)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(accessAction)

        present(alertController, animated: true, completion: nil)
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
                cell.openHour = openHours[indexPath.row - 1]
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
        case .telephone(let telephone):
            telephoneCell.contact.text = telephone
            telephoneCell.indexPath = indexPath

            return telephoneCell
        case .website(let website):
            websiteCell.contact.text = website
            websiteCell.indexPath = indexPath

            return websiteCell
        case .report:
            return reportAnIssueCell
        }
    }

}

// MARK: UITableViewDelegate

extension FacilityDetailsTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]

        switch section {
        case .openHours where indexPath.row == 0:
            return OpenHoursTodayTableViewCell.rowHeight
        case .openHours(let openHours):
            if indexPath.row == 1 && openHours.count == 1 {
                return OpenHoursTableViewCell.topShrinkedBottomExtendedRowHeight
            }

            if indexPath.row == 1 {
                return OpenHoursTableViewCell.topShrinkedRowHeight
            }

            if openHours.count == indexPath.row {
                return OpenHoursTableViewCell.bottomExtendedRowHeight
            }

            return OpenHoursTableViewCell.estimatedRowHeight
        case .telephone, .website:
            return ContactTableViewCell.rowHeight
        case .report:
            return ReportIssueTableViewCell.rowHeight
        }
    }

}

// MARK: OpenHoursTodayTableViewCellDelegate

extension FacilityDetailsTableViewController: OpenHoursTodayTableViewCellDelegate {

    func didTouchCollapseButton(_ button: UIButton) {
        button.setTitle(openHoursCollapseButtonTitle, for: .normal)
        isOpenHoursCollapsed = !isOpenHoursCollapsed

        if isOpenHoursCollapsed {
            if let indexPath = openHoursIndexPaths.last,
                    let cell = tableView.cellForRow(at: indexPath) as? OpenHoursTableViewCell {
                if cell.shouldShowSeparator {
                    cell.shouldShowSeparator = false
                }
            }
            openHoursTodayCell.shouldShowSeparator = true
            tableView.deleteRows(at: openHoursIndexPaths, with: .automatic)
        } else {
            openHoursTodayCell.shouldShowSeparator = false
            tableView.insertRows(at: openHoursIndexPaths, with: .automatic)
        }
    }

}

// MARK: TelephoneTableViewCellDelegate

extension FacilityDetailsTableViewController: ContactTableViewCellDelegate {

    func didTouchContactButton(atIndexPath indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .telephone(let telephone):
            call(telephone: telephone)
        case .website(let website):
            goTo(website: website)
        default:
            break
        }
    }

}

// MARK: ReportIssueTableViewCellDelegate

extension FacilityDetailsTableViewController: ReportIssueTableViewCellDelegate {

    func didTouchReportIssueButton() {
        let alertController = UIAlertController(title: nil, message: "Not available yet", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

}
