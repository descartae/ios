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

    var dataManager = DataManager.shared

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

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
        tableView.register(LoadingMoreTableViewCell.nib, forCellReuseIdentifier: LoadingMoreTableViewCell.identifier)

        refreshControl.addTarget(self, action: #selector(refreshFacilities), for: .valueChanged)
        tableView.refreshControl = refreshControl

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic

        } else {
            // Fallback on earlier versions
        }
    }

    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(reloadFacilities), name: facilitiesDataUpdated, object: nil)
    }

    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: facilitiesDataUpdated, object: nil)
    }

    // MARK: Data handling

    @objc func reloadFacilities() {
        tableView.reloadData()
    }

    @objc func refreshFacilities() {
        dataManager.loadData { _ in
            let endRefreshingOp = BlockOperation(block: {
                self.refreshControl.endRefreshing()
            })

            let reloadTableViewOp = BlockOperation(block: {
                self.tableView.reloadData()
            })

            endRefreshingOp.addDependency(reloadTableViewOp)

            OperationQueue.main.addOperation {
                reloadTableViewOp.start()
            }

            OperationQueue.main.addOperation {
                endRefreshingOp.start()
            }
        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let details = segue.destination as? FacilityDetailsTableViewController, let indexOfFacility = sender as? Int {
            details.facility = dataManager.data.facilities[indexOfFacility]
        }
    }

}

// MARK: UITableViewDataSource

extension FacilitiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.data.facilities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == dataManager.data.facilities.count - 1 && dataManager.data.after != nil {
            dataManager.loadMoreData(completionHandler: { (_) in
                self.tableView.reloadData()
            })
            let loadingMoreCell = tableView.dequeueReusableCell(withIdentifier: LoadingMoreTableViewCell.identifier, for: indexPath)

            return loadingMoreCell
        }

        if let facilityCell = tableView.dequeueReusableCell(withIdentifier: FacilityTableViewCell.identifier, for: indexPath) as? FacilityTableViewCell {
            facilityCell.facility = dataManager.data.facilities[indexPath.row]

            return facilityCell
        }

        return UITableViewCell()
    }

}

extension FacilitiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.navigationBar.isTranslucent = true
        performSegue(withIdentifier: "showFacilityDetails", sender: indexPath.row)
    }

}
