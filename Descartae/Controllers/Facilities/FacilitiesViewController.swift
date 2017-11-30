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

    let locationManager = LocationManager.shared
    var facilities: [Facility] = []
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

        setupTableView()
        setupLocationState()
    }

    // MARK: Initial setups

    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = FacilityTableViewCell.estimatedRowHeight

        tableView.register(FacilityTableViewCell.nib, forCellReuseIdentifier: FacilityTableViewCell.identifier)

        refreshControl.addTarget(self, action: #selector(refreshFacilities), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func setupLocationState() {
        if locationManager.shouldAskForAuthorization {
            // TODO: Setup ask permission state
            locationManager.askForAuthorization()
        }

        if locationManager.isLocationDenied {
            // TODO: Setup location denied state
        }

        locationManager.onLocationUpdate { [weak self] in
            self?.loadFacilities()
        }
    }

    // MARK: Data handling

    func loadFacilities() {
        isLoading = true
        tableView.reloadData()
        let allFacilities = AllFacilitiesQuery()
        GraphQL.client.fetch(query: allFacilities) { (result, error) in
            self.isLoading = false

            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            guard let centersQueryFragment = result?.data?.centers as? [AllFacilitiesQuery.Data.Center] else {
                return
            }

            self.facilities = centersQueryFragment.map({ $0.fragments.facility })
            self.tableView.reloadData()
        }
    }

    @objc func refreshFacilities() {
        let allFacilities = AllFacilitiesQuery()
        GraphQL.client.fetch(query: allFacilities) { (result, error) in
            self.refreshControl.endRefreshing()

            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            guard let facilitiesQueryFragment = result?.data?.centers as? [AllFacilitiesQuery.Data.Center] else {
                return
            }

            self.facilities = facilitiesQueryFragment.map({ $0.fragments.facility })
            self.tableView.reloadData()
        }
    }

}

// MARK: UITableViewDataSource

extension FacilitiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            tableView.backgroundView = activityIndicator
            return 0
        }

        return facilities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let facilityCell = tableView.dequeueReusableCell(withIdentifier: FacilityTableViewCell.identifier, for: indexPath) as? FacilityTableViewCell {
            facilityCell.facility = facilities[indexPath.row]

            return facilityCell
        }

        return UITableViewCell()
    }

}
