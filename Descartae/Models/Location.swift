//
//  Location.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 09/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import CoreLocation

extension DisposalFacility.Location {

    var location: CLLocation {
        return CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }

}
