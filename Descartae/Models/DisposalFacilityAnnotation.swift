//
//  DisposalFacilityAnnotation.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 24/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import Foundation
import MapKit

class DisposalFacilityAnnotation: NSObject, MKAnnotation {

    // MARK: Properties

    static let identifier = String(describing: DisposalFacilityAnnotation.self)

    var facility: DisposalFacility
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D

    init(facility: DisposalFacility) {
        self.facility = facility
        self.title = facility.name
        self.subtitle = facility.location.address
        self.coordinate = facility.location.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)

        super.init()
    }

}
