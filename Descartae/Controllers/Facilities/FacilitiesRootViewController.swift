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

    var dataManager = DataManager.shared
    let locationManager = LocationManager.shared

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadingStyle()
        setupLocationState()
        setupFilterButton()
        configureContainer(withViewController: facilitiesViewController)
    }

    // MARK: Initial setups

    func setupLocationState() {
        if locationManager.shouldAskForAuthorization {
            // TODO: Setup ask permission state
            locationManager.askForAuthorization()
        }

        if locationManager.isLocationDenied {
            // TODO: Setup location denied state
        }

        locationManager.onLocationUpdate { [weak self] in
            SVProgressHUD.show()
            self?.dataManager.loadData(completionHandler: { (_) in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            })
        }
    }

    func setupLoadingStyle() {
        var navigationBarOffset: CGFloat = navigationController?.navigationBar.bounds.height ?? 0
        navigationBarOffset = navigationBarOffset == 0 ? 0 : navigationBarOffset - 42
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
            filterFacilities.wasteTypes = self.dataManager.data.wasteTypes
            filterFacilities.wasteTypesToFilter = self.dataManager.data.filteringByWasteTypes
            filterFacilities.applyFilter = { wasteTypesToFilter in
                self.dataManager.data.filteringByWasteTypes = wasteTypesToFilter
                self.filterButton.badgeValue = "\(self.dataManager.data.filteringByWasteTypes.count)"
                SVProgressHUD.show()
                self.dataManager.loadData(completionHandler: { (_) in
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                })
            }
        }

        if let nav = segue.destination as? UINavigationController, let info = nav.childViewControllers[0] as? InfoTableViewController {
            info.wasteTypes = dataManager.data.wasteTypes
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
