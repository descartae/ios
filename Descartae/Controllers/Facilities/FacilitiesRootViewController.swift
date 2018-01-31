//
//  FacilitiesContainerViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 20/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit
import BBBadgeBarButtonItem
import SVProgressHUD

class FacilitiesRootViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var contentSegmentControl: UISegmentedControl!

    var filterButton: BBBadgeBarButtonItem!
    var currentViewOnContainer: UIViewController!
    var firstSegmentViewController: UIViewController!

    lazy var facilitiesViewController: FacilitiesViewController! = {
        let mainStoryboard = UIStoryboard.mainStoryboard
        let facilities = mainStoryboard.instantiateViewController(withIdentifier: FacilitiesViewController.identifier) as? FacilitiesViewController

        return facilities
    }()

    lazy var facilitiesMapViewController: FacilitiesMapViewController! = {
        let mainStoryboard = UIStoryboard.mainStoryboard
        let facilitiesMap = mainStoryboard.instantiateViewController(withIdentifier: FacilitiesMapViewController.identifier) as? FacilitiesMapViewController

        return facilitiesMap
    }()

    lazy var locationPermissionViewController: LocationPermissionViewController! = {
        let mainStoryboard = UIStoryboard.mainStoryboard
        let locationPermission = mainStoryboard.instantiateViewController(withIdentifier: LocationPermissionViewController.identifier) as? LocationPermissionViewController

        return locationPermission
    }()

    lazy var offlineStateViewController: OfflineStateViewController! = {
        let mainStoryboard = UIStoryboard.mainStoryboard
        let offlineState = mainStoryboard.instantiateViewController(withIdentifier: OfflineStateViewController.identifier) as? OfflineStateViewController

        return offlineState
    }()

    lazy var emptyStateViewController: EmptyStateViewController! = {
        let mainStoryboard = UIStoryboard.mainStoryboard
        let emptyState = mainStoryboard.instantiateViewController(withIdentifier: EmptyStateViewController.identifier) as? EmptyStateViewController

        return emptyState
    }()

    lazy var unavailableRegionViewController: UnavailableRegionViewController! = {
        let mainStoryboard = UIStoryboard.mainStoryboard
        let unavailableRegion = mainStoryboard.instantiateViewController(withIdentifier: UnavailableRegionViewController.identifier) as? UnavailableRegionViewController

        return unavailableRegion
    }()

    let locationManager = LocationManager.shared

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        setupLoadingStyle()
        loadDataIfLocationIsAvailable()
        setupFilterButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.navigationBar.isTranslucent = false
    }

    // MARK: Initial setups

    func loadDataIfLocationIsAvailable() {
        guard locationManager.location != nil, !locationManager.shouldAskForAuthorization, !locationManager.isLocationDenied else {
            locationManager.onLocationUpdate {
                self.loadData(shouldResetLocationSubscriptions: true)
            }

            firstSegmentViewController = locationPermissionViewController
            configureContainer(withViewController: locationPermissionViewController)

            return
        }

        loadData()
    }

    func setupLoadingStyle() {
        var navigationBarOffset: CGFloat = navigationController?.navigationBar.bounds.height ?? 0
        navigationBarOffset = navigationBarOffset == 0 ? 0 : navigationBarOffset - 42
        SVProgressHUD.setForegroundColor(AppearanceManager.tintColor)
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: navigationBarOffset))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }

    func setupFilterButton() {
        let customButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        customButton.addTarget(self, action: #selector(presentFilterFacilities), for: .touchUpInside)
        customButton.setImage(UIImage(named: "icFilter"), for: .normal)

        filterButton = BBBadgeBarButtonItem(customUIButton: customButton)
        filterButton.badgeMinSize = 16
        filterButton.badgeFont = UIFont.systemFont(ofSize: 11, weight: .semibold)
        filterButton.badgePadding = 2
        filterButton.badgeOriginX = 22
        filterButton.badgeOriginY = 6
        navigationItem.setRightBarButton(filterButton, animated: false)
    }

    // MARK: Networking

    func loadData(isFiltering: Bool = false, shouldResetLocationSubscriptions: Bool = false) {
        SVProgressHUD.show()
        APIManager.loadData(completionHandler: { (_) in
            if shouldResetLocationSubscriptions { self.locationManager.resetLocationUpdateSubscriptions() }
            self.handleState(isFiltering: isFiltering)
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        })
    }

    func handleState(isFiltering: Bool = false) {
        let setupOfflineState = {
            self.firstSegmentViewController = self.offlineStateViewController
            if self.contentSegmentControl.selectedSegmentIndex == 0 {
                self.configureContainer(withViewController: self.offlineStateViewController)
            }
        }

        if !APIManager.isReachable {
            setupOfflineState()
            return
        }

        if DataStore.facilities.count == 0 && APIManager.filteringByWasteTypes.isEmpty {
            firstSegmentViewController = unavailableRegionViewController
            if contentSegmentControl.selectedSegmentIndex == 0 {
                configureContainer(withViewController: unavailableRegionViewController)
            }

            return
        }

        if  DataStore.facilities.count == 0 && !APIManager.filteringByWasteTypes.isEmpty && isFiltering {
            firstSegmentViewController = emptyStateViewController
            if contentSegmentControl.selectedSegmentIndex == 0 {
                configureContainer(withViewController: emptyStateViewController)
            }

            return
        }

        // If there is no filter and no facility to show we fallback to offline state since it points to a unavailability of our servers
        if DataStore.facilities.count == 0 {
            setupOfflineState()
            return
        }

        firstSegmentViewController = facilitiesViewController
        if contentSegmentControl.selectedSegmentIndex == 0 {
            configureContainer(withViewController: facilitiesViewController)
        }
    }

    // MARK: Actions

    @IBAction func updateListingMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            configureContainer(withViewController: firstSegmentViewController)
        case 1:
            configureContainer(withViewController: facilitiesMapViewController)
        default:
            break
        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterFacilities = segue.destination as? FilterFacilitiesViewController {
            filterFacilities.applyFilters = {
                self.filterButton.badgeValue = "\(APIManager.filteringByWasteTypes.count)"
                DataStore.resetFacilities()
                SVProgressHUD.show()
                self.loadData(isFiltering: true)
            }
        }

    }

    func configureContainer(withViewController viewController: UIViewController) {
        if currentViewOnContainer != nil {
            currentViewOnContainer.view.removeFromSuperview()
            deactivatePinConstraints(forSubview: currentViewOnContainer.view)
            currentViewOnContainer.removeFromParentViewController()
            addChildViewController(viewController)
            contentContainer.addSubview(viewController.view)
            pinOnContainer(viewController.view)
            currentViewOnContainer = viewController

            return
        }

        addChildViewController(viewController)
        contentContainer.addSubview(viewController.view)
        pinOnContainer(viewController.view)
        viewController.didMove(toParentViewController: self)
        currentViewOnContainer = viewController
    }

    func pinOnContainer(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: contentContainer.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor).isActive = true

        contentContainer.layoutIfNeeded()
    }

    func deactivatePinConstraints(forSubview subview: UIView) {
        subview.topAnchor.constraint(equalTo: contentContainer.topAnchor).isActive = false
        subview.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor).isActive = false
        subview.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor).isActive = false
        subview.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor).isActive = false
    }

    @objc func presentFilterFacilities() {
        performSegue(withIdentifier: "presentFilterFacilities", sender: self)
    }

}
