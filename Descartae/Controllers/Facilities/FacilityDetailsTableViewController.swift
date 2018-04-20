//
//  FacilityDetailsTableViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 02/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit
import SafariServices
import MapKit
import CMMapLauncher

// swiftlint:disable file_length type_body_length
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

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var facilityName: UILabel!
    @IBOutlet weak var facilityAddress: UILabel!
    @IBOutlet weak var facilityNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var facilityAddressHeightConstraint: NSLayoutConstraint!

    var headerViewDefaultHeight: CGFloat!
    var isComingFromPortrait = true

    @IBOutlet weak var routeButton: UIButton! {
        didSet {
            routeButton.setTitle(localized("route_to_facility"), for: .normal)
        }
    }

    @IBOutlet weak var wasteTypesTitle: UILabel! {
        didSet {
            wasteTypesTitle.text = localized("waste_types_title")
        }
    }

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

        cell.contactType.text = localized("telephone_contact_title")
        cell.contactActionButton.setTitle(localized("telephone_action_title"), for: .normal)
        cell.delegate = self
        return cell
    }()

    lazy var websiteCell: ContactTableViewCell = {
        guard let cell = ContactTableViewCell.instantiateFromNib() else {
            return ContactTableViewCell()
        }

        cell.contactType.text = localized("website_contact_title")
        cell.contactActionButton.setTitle(localized("website_action_title"), for: .normal)
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
        return isOpenHoursCollapsed ? localized("open_hours_expanded_title") : localized("open_hours_collapsed_title")
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        navigationItem.title = localized("facility_details_title")

        setupTableView()
        setupSections()
        bindTableViewHeaderData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resizeElementsBasedOnContent()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { _ in
            if size.height < size.width {
                if self.isComingFromPortrait {
                    self.moveCenterByOffset(offset: CGPoint(x: 0, y: -216), from: self.facility.location.location.coordinate, animated: false)
                    self.isComingFromPortrait = false
                }
            } else {
                if !self.isComingFromPortrait {
                    self.moveCenterByOffset(offset: CGPoint(x: 0, y: -716), from: self.facility.location.location.coordinate, animated: false)
                    self.isComingFromPortrait = true
                }
            }
        }
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

    func setupMapView() {
        mapView.delegate = self
        setupAnnotation(-400)
    }

    private func setupAnnotation(_ yOffset: CGFloat, animated: Bool = true) {
        let facilityLocation = facility.location.location
        let annotation = MKPointAnnotation()
        annotation.coordinate = facilityLocation.coordinate

        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
        let adjusted = mapView.regionThatFits(region)
        mapView.setRegion(adjusted, animated: false)

        moveCenterByOffset(offset: CGPoint(x: 0, y: yOffset), from: facilityLocation.coordinate, animated: animated)
    }

    func moveCenterByOffset(offset: CGPoint, from coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        var point = mapView.convert(coordinate, toPointTo: mapView)
        point.x += offset.x
        point.y += offset.y

        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        mapView.setCenter(coordinate, animated: animated)
    }

    func bindTableViewHeaderData() {
        setupMapView()

        let facilityNameParagraph = NSMutableParagraphStyle()
        facilityNameParagraph.lineSpacing = 1.5
        let attributedName = NSAttributedString(string: facility.name, attributes: [NSAttributedStringKey.paragraphStyle: facilityNameParagraph])

        let facilityAddressParagraph = NSMutableParagraphStyle()
        facilityAddressParagraph.lineSpacing = 1
        let attributedAddress = NSAttributedString(string: facility.location.address, attributes: [NSAttributedStringKey.paragraphStyle: facilityAddressParagraph])

        facilityName.attributedText = attributedName
        facilityAddress.attributedText = attributedAddress

        guard let routeCurrentTitle = routeButton.title(for: .normal) else {
            return
        }

        routeButton.titleLabel?.numberOfLines = 0

        let routeTitleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        let distanceFromUserAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .regular)]

        let routeTitle = NSMutableAttributedString(string: routeCurrentTitle, attributes: routeTitleAttributes)
        let distanceFromUser = NSMutableAttributedString(string: "\n\(facility.distanceFromUser.lowercased())", attributes: distanceFromUserAttributes)

        let combination = NSMutableAttributedString()
        combination.append(routeTitle)
        combination.append(distanceFromUser)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.alignment = .center

        let combinationRange = NSRange(location: 0, length: combination.length)
        combination.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: combinationRange)

        routeButton.setAttributedTitle(combination, for: .normal)
    }

    func resizeElementsBasedOnContent() {
        if headerViewDefaultHeight == nil {
            headerViewDefaultHeight = headerView.bounds.height
        }

        headerView.frame = CGRect(
            x: headerView.frame.origin.x,
            y: headerView.frame.origin.y,
            width: headerView.frame.width,
            height: calculateHeaderViewHeightBasedOnContent()
        )

        tableView.tableHeaderView = headerView
        tableView.reloadData()
    }

    func calculateHeaderViewHeightBasedOnContent() -> CGFloat {
        view.layoutIfNeeded()

        let facilityNameHeightToFitContent = facilityName.bounds.height - facilityNameHeightConstraint.constant
        let facilityAddressHeightToFitContent = facilityAddress.bounds.height - facilityAddressHeightConstraint.constant

        return headerViewDefaultHeight +
            facilityNameHeightToFitContent +
            facilityAddressHeightToFitContent
    }

    // MARK: Actions

    @IBAction func showRouteOptions(_ sender: UIButton) {
        let facilityCoordinates = facility.location.location.coordinate
        let mapPoint = CMMapPoint(address: facility.location.address, coordinate: facilityCoordinates)
        let chooseMapAlert = UIAlertController(title: localized("routes_app_selection_title"), message: nil, preferredStyle: .actionSheet)

        let isAppleMapsInstalled = CMMapLauncher.isMapAppInstalled(CMMapApp.appleMaps)
        let isGoogleMapsInstalled = CMMapLauncher.isMapAppInstalled(CMMapApp.googleMaps)
        let isWazeInstalled = CMMapLauncher.isMapAppInstalled(CMMapApp.waze)

        if isAppleMapsInstalled {
            let appleMapsAction = UIAlertAction(title: localized("apple_maps_title"), style: .default, handler: { _ in
                CMMapLauncher.launch(CMMapApp.appleMaps, forDirectionsTo: mapPoint)
            })

            chooseMapAlert.addAction(appleMapsAction)
        }

        if isGoogleMapsInstalled {
            let appleMapsAction = UIAlertAction(title: localized("google_maps_title"), style: .default, handler: { _ in
                CMMapLauncher.launch(CMMapApp.googleMaps, forDirectionsTo: mapPoint)
            })

            chooseMapAlert.addAction(appleMapsAction)
        }

        if isWazeInstalled {
            let appleMapsAction = UIAlertAction(title: localized("waze_title"), style: .default, handler: { _ in
                CMMapLauncher.launch(CMMapApp.waze, forDirectionsTo: mapPoint)
            })

            chooseMapAlert.addAction(appleMapsAction)
        }

        let cancelAction = UIAlertAction(title: localized("cancel"), style: .cancel, handler: nil)
        chooseMapAlert.addAction(cancelAction)

        present(chooseMapAlert, animated: true, completion: nil)
    }

    @IBAction func shareIt(_ sender: UIBarButtonItem) {
        guard let shareURL = URL(string: "https://descartae.com/facility.html?id=\(facility.id)") else {
            return
        }

        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (content, completed, items, error) -> Void in
            if completed {
                if content == UIActivityType.copyToPasteboard {
                    DispatchQueue.main.async {
                        let successMessage = UIAlertController(title: localized("greeting_alert_title"), message: localized("shared_to_clipboard_alert_message"), preferredStyle: .alert)
                        let okAction = UIAlertAction(title: localized("thank_you"), style: .default, handler: nil)

                        successMessage.addAction(okAction)

                        self.present(successMessage, animated: true, completion: nil)
                    }
                } else {
                    self.complimentForTheShare()
                }
            }
        }

        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    func complimentForTheShare() {
        DispatchQueue.main.async {
            let successMessage = UIAlertController(title: localized("greeting_alert_title"), message: localized("compliment_for_sharing_alert_message"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: localized("spread_the_word"), style: .default, handler: nil)

            successMessage.addAction(okAction)

            self.present(successMessage, animated: true, completion: nil)
        }
    }

    func call(telephone: String) {
        let trimmedPhone = telephone.replacingOccurrences(of: " ", with: "")

        guard let url = URL(string: "tel://\(trimmedPhone)"), UIApplication.shared.canOpenURL(url) else {
            return
        }

        UIApplication.shared.open(url)
    }

    func goTo(website: String) {
        guard let url = URL(string: website) else {
            return
        }

        let alertController = UIAlertController(title: website, message: localized("open_website_title"), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: localized("cancel"), style: .cancel, handler: nil)
        let accessAction = UIAlertAction(title: localized("open_website_action"), style: .default) {  _ in
            let safari = SFSafariViewController(url: url)
            safari.modalPresentationStyle = .popover

            self.present(safari, animated: true, completion: nil)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(accessAction)

        present(alertController, animated: true, completion: nil)
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let typesOfWastePreview = segue.destination as? TypesOfWastePreviewViewController {
            typesOfWastePreview.typesOfWaste = facility.typesOfWaste.compactMap { $0 }
        }
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
        guard let storyboard = storyboard else {
            return
        }

        let reportAnIssueNav = storyboard.instantiateViewController(withIdentifier: ReportAnIssueNavigationController.identifier)

        guard let reportAnIssueTableViewController = reportAnIssueNav.childViewControllers[0] as? ReportAnIssueTableViewController else {
            return
        }

        reportAnIssueTableViewController.facility = facility
        present(reportAnIssueNav, animated: true, completion: nil)
    }

}

// MARK: MKMapViewDelegate

extension FacilityDetailsTableViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.canShowCallout = false
        annotationView.image = UIImage(named: "icPin")

        return annotationView
    }

}
