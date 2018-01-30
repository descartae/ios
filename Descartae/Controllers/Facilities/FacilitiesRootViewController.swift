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

    var filterButton: BBBadgeBarButtonItem!
    var currentViewOnContainer: UIViewController!

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
        getLocationAndDefineState()
        setupFilterButton()
        configureContainer(withViewController: facilitiesViewController)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.navigationBar.isTranslucent = false
    }

    // MARK: Initial setups

    func getLocationAndDefineState() {
        let handleState = {
            if DataStore.facilities.count == 0 && DataStore.filteringByWasteTypes.isEmpty {
                self.configureContainer(withViewController: self.unavailableRegionViewController)
                return
            }

            if DataStore.facilities.count == 0 {
                self.configureContainer(withViewController: self.offlineStateViewController)
                return
            }

            self.configureContainer(withViewController: self.facilitiesViewController)
        }

        guard locationManager.location != nil, !locationManager.shouldAskForAuthorization, !locationManager.isLocationDenied else {
            locationManager.onLocationUpdate {
                SVProgressHUD.show()
                APIManager.loadData(completionHandler: { (_) in
                    self.locationManager.resetLocationUpdateSubscriptions()
                    handleState()
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                })
            }

            configureContainer(withViewController: locationPermissionViewController)

            return
        }
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

    // MARK: Actions

    @IBAction func updateListingMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            configureContainer(withViewController: facilitiesViewController)
        case 1:
            configureContainer(withViewController: facilitiesMapViewController)
        default:
            break
        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterFacilities = segue.destination as? FilterFacilitiesViewController {
            filterFacilities.updateFilterIconBadge = {
                self.filterButton.badgeValue = "\(DataStore.filteringByWasteTypes.count)"
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
