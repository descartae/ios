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

    var location: CLLocation? {
        guard let latitude = coordinates?.latitude, let longitude = coordinates?.longitude else {
            return nil
        }

        return CLLocation(latitude: latitude, longitude: longitude)
    }

}
