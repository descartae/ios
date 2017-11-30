//
//  LocationManager.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 28/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {

    // MARK: Properties

    static let shared: LocationManager = LocationManager()

    private let manager: CLLocationManager = CLLocationManager()
    var location: CLLocation? {
        return manager.location
    }

    var shouldAskForAuthorization: Bool {
        return CLLocationManager.authorizationStatus() == .notDetermined
    }

    var isLocationDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }

    private var locationUpdateSubscriptions: [() -> Void] = []

    // MARK: Init

    override init() {
        super.init()
        manager.distanceFilter = 5000
        manager.delegate = self
    }

    // MARK: Updating location

    func askForAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func onLocationUpdate(_ closure: @escaping () -> Void) {
        locationUpdateSubscriptions.append(closure)
    }

    func updateLocation() {
        manager.startUpdatingLocation()
    }

    // MARK: Utils

    func distanceInKm(fromLocation location: CLLocation?) -> Double {
        guard let userLocation = self.location, let facilityLocation = location else {
            return 0
        }

        return userLocation.distance(from: facilityLocation) / 1000
    }

}

// MARK: CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = locationUpdateSubscriptions.map { $0() }
    }

}
