//
//  LocationPermissionViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 29/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class LocationPermissionViewController: UIViewController {

    // MARK: Properties

    static let identifier = String(describing: LocationPermissionViewController.self)

    @IBOutlet weak var locationPermissionTitle: UILabel! {
        didSet {
            locationPermissionTitle.text = localized("enable_location_title")
        }
    }

    @IBOutlet weak var locationPermissionSubtitle: UILabel! {
        didSet {
            locationPermissionSubtitle.text = localized("enable_location_subtitle")
        }
    }

    @IBOutlet weak var allowLocationButton: UIButton! {
        didSet {
            allowLocationButton.setTitle(localized("allow_location_button_title"), for: .normal)
        }
    }

    let locationManager = LocationManager.shared

    // MARK: Actions

    @IBAction func grantLocationPermission(_ sender: Any) {
        if locationManager.shouldAskForAuthorization {
            locationManager.askForAuthorization()
            return
        }

        if let prefsURL = URL(string: UIApplicationOpenSettingsURLString), locationManager.isLocationDenied {
            UIApplication.shared.open(prefsURL)
            return
        }

        let alreadyGrantedPermission = UIAlertController(title: localized("whoops"), message: localized("already_have_location_message"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: localized("ok"), style: .default, handler: { _ in
            self.locationManager.updateLocation()
        })
        alreadyGrantedPermission.addAction(okAction)

        present(alreadyGrantedPermission, animated: true, completion: nil)
    }

}
