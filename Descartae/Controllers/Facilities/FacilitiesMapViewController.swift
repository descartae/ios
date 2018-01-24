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

    let dataManager = DataManager.shared

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addFacilityAnnotations()
    }

    // MARK: MapView setup

    func addFacilityAnnotations() {
        for facility in dataManager.data.facilities {
            let annotation = DisposalFacilityAnnotation(facility: facility)
            mapView.addAnnotation(annotation)
        }
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
