//
//  FacilitiesViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 18/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit
import CoreLocation

final class FacilitiesViewController: UIViewController {

    // MARK: Properties

    static let identifier = String(describing: FacilitiesViewController.self)

    @IBOutlet weak var tableView: UITableView!

    var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()

    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .gray

        return activityIndicator
    }()

    var dataManager = FacilitiesDataManager.shared

    var isLoading: Bool = true {
        didSet {
            if !isLoading { tableView.backgroundView = nil }
        }
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }

        addObservers()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPathOfSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathOfSelectedRow, animated: true)
        }
    }

    deinit {
        removeObservers()
    }

    // MARK: Initial setups

    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = FacilityTableViewCell.estimatedRowHeight

        tableView.register(FacilityTableViewCell.nib, forCellReuseIdentifier: FacilityTableViewCell.identifier)

        refreshControl.addTarget(self, action: #selector(refreshFacilities), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(reloadFacilities), name: facilitiesDataUpdatedNotification, object: nil)
    }

    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: facilitiesDataUpdatedNotification, object: nil)
    }

    // MARK: Data handling

    @objc func reloadFacilities() {
        tableView.reloadData()
    }

    @objc func refreshFacilities() {
//        GraphQL.client.fetch(query: allFacilitiesQuery) { (result, error) in
//            self.refreshControl.endRefreshing()
//
//            guard error == nil else {
//                print(error?.localizedDescription ?? "")
//                return
//            }
//
//            guard let facilitiesQueryFragment = result?.data?.facilities?.items as? [AllFacilitiesQuery.Data.Facility.Item] else {
//                return
//            }
//
//            guard let typesOfWasteQueryFragment = result?.data?.typesOfWaste as? [AllFacilitiesQuery.Data.TypesOfWaste] else {
//                return
//            }
//
//            self.wasteTypes = typesOfWasteQueryFragment.map({ $0.fragments.wasteType })
//            self.facilities = facilitiesQueryFragment.map({ $0.fragments.disposalFacility })
//            self.tableView.reloadData()
//        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let details = segue.destination as? FacilityDetailsTableViewController, let indexOfFacility = sender as? Int {
            details.facility = dataManager.data.facilities[indexOfFacility]
        }

//        if let filterFacilities = segue.destination as? FilterFacilitiesViewController {
//            filterFacilities.wasteTypes = wasteTypes
//            filterFacilities.wasteTypesToFilter = filteringByWasteTypes
//            filterFacilities.applyFilter = { wasteTypesToFilter in
//                self.filteringByWasteTypes = wasteTypesToFilter
//                self.filterButton.badgeValue = "\(self.filteringByWasteTypes.count)" // TODO: Update filter button
//                self.allFacilitiesQuery.typesOfWasteToFilter = self.filteringByWasteTypes.map {$0.id}
//                self.loadFacilities()
//            }
//        }
//
//        if let nav = segue.destination as? UINavigationController, let info = nav.childViewControllers[0] as? InfoTableViewController {
//            info.wasteTypes = wasteTypes
//        }

    }

}

// MARK: UITableViewDataSource

extension FacilitiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isLoading {
//            tableView.backgroundView = activityIndicator
//            return 0
//        }

        return dataManager.data.facilities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let facilityCell = tableView.dequeueReusableCell(withIdentifier: FacilityTableViewCell.identifier, for: indexPath) as? FacilityTableViewCell {
            facilityCell.facility = dataManager.data.facilities[indexPath.row]

            return facilityCell
        }

        return UITableViewCell()
    }

}

extension FacilitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFacilityDetails", sender: indexPath.row)
    }

}
