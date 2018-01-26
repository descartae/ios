//
//  FacilitiesMapViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 20/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit
import MapKit

class FacilitiesMapViewController: UIViewController {

    // MARK: Properties

    static let identifier = String(describing: FacilitiesMapViewController.self)

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadMoreButton: FacilitiesMapButton!

    let dataManager = DataManager.shared
    let locationManager = LocationManager.shared

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addObservers()
        addFacilityAnnotations()
    }

    deinit {
        removeObservers()
    }

    // MARK: Setup

    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(reloadMapView), name: facilitiesDataUpdated, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showLoadMoreButton), name: nextPageAvailable, object: nil)
        notificationCenter.addObserver(self, selector: #selector(hideLoadMoreButton), name: nextPageUnavailable, object: nil)
    }

    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: facilitiesDataUpdated, object: nil)
        notificationCenter.removeObserver(self, name: nextPageAvailable, object: nil)
        notificationCenter.removeObserver(self, name: nextPageUnavailable, object: nil)
    }

    @objc func showLoadMoreButton() {
        guard loadMoreButton.isHidden else {
            return
        }

        UIView.animate(withDuration: 0.125, animations: {
            self.loadMoreButton.alpha = 1
        }, completion: { _ in
            self.loadMoreButton.isHidden = false
        })
    }

    @objc func hideLoadMoreButton() {
        guard !loadMoreButton.isHidden else {
            return
        }

        UIView.animate(withDuration: 0.125, animations: {
            self.loadMoreButton.alpha = 0
        }, completion: { _ in
            self.loadMoreButton.isHidden = true
        })
    }

    // MARK: MapView setup

    @objc func reloadMapView() {
        mapView.removeAnnotations(mapView.annotations)
        addFacilityAnnotations(shouldAdjustZoom: false)
    }

    func addFacilityAnnotations(shouldAdjustZoom: Bool = true) {
        for facility in dataManager.data.facilities {
            let annotation = DisposalFacilityAnnotation(facility: facility)
            mapView.addAnnotation(annotation)
        }

        if shouldAdjustZoom {
            zoomToFitAllAnnotations()
        }
    }

    func zoomToFitAllAnnotations() {
        guard mapView.annotations.count > 0 else {
            return
        }

        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)

        // Fit the most distant annotation in the region
        for annotation in mapView.annotations {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }

        // Consider user location in the region, if it is available
        if let userCoordinate = locationManager.location?.coordinate {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, userCoordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, userCoordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, userCoordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, userCoordinate.latitude)
        }

        var region = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2

        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }

    // MARK: Actions

    @IBAction func loadMoreFacilities(_ sender: FacilitiesMapButton) {
        guard dataManager.data.after != nil else {
            return
        }

        sender.startLoading()
        dataManager.loadMoreData { _ in
            self.zoomToFitAllAnnotations()
            sender.stopLoading()
        }
    }

    @IBAction func zoomToFitsUserAndFacilities(_ sender: Any) {
        zoomToFitAllAnnotations()
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let facilityDetails = segue.destination as? FacilityDetailsTableViewController, let annotation = sender as? DisposalFacilityAnnotation {
            facilityDetails.facility = annotation.facility
        }
    }

}

// MARK: MKMapViewDelegate

extension FacilitiesMapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: DisposalFacilityAnnotation.identifier) {
            annotationView.annotation = annotation

            return annotationView
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: DisposalFacilityAnnotation.identifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.image = UIImage(named: "icPin")

            return annotationView
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        navigationController?.navigationBar.isTranslucent = true
        performSegue(withIdentifier: "showFacilityDetails", sender: view.annotation)
    }

}
