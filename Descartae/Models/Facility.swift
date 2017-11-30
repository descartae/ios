//
//  Center.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 20/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo
import CoreLocation

extension Facility: Equatable {

    public static func == (lhs: Facility, rhs: Facility) -> Bool {
        return lhs.id == rhs.id
    }

}

extension Facility.Location {

    var location: CLLocation? {
        guard let latitude = coordinates?.latitude, let longitude = coordinates?.longitude else {
            return nil
        }
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }

}
