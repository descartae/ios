//
//  DisposalFacility.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 20/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo
import CoreLocation

extension DisposalFacility: Equatable {

    public static func == (lhs: DisposalFacility, rhs: DisposalFacility) -> Bool {
        return lhs.id == rhs.id
    }

}

extension DisposalFacility.Location {

    var location: CLLocation? {
        guard let latitude = coordinates?.latitude, let longitude = coordinates?.longitude else {
            return nil
        }

        return CLLocation(latitude: latitude, longitude: longitude)
    }

}
