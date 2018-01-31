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

        let alreadyGrantedPermission = UIAlertController(title: "Opa!", message: "Você já permitiu o uso da sua localização;", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tudo bem", style: .default, handler: { _ in
            self.locationManager.updateLocation()
        })
        alreadyGrantedPermission.addAction(okAction)

        present(alreadyGrantedPermission, animated: true, completion: nil)
    }

}
