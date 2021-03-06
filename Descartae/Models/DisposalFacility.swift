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

    var wasteTypes: [WasteType] {
        return self.typesOfWaste.compactMap({ $0?.fragments.wasteType })
    }

    var distanceFromUser: String {
        return String(format: "%.2fKM", LocationManager.shared.distanceInKm(fromLocation: location.location))
    }

    var openHoursForToday: String {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let weekday = calendar.component(.weekday, from: Date())
        guard let todayOpenHour = openHours.filter({ $0?.dayOfWeek.toInt == weekday }).first as? DisposalFacility.OpenHour else {
            return localized("today_open_hours_unavailable")
        }

        return "\(localized("today_title")) - \(todayOpenHour.openHours)"
    }

    public static func == (lhs: DisposalFacility, rhs: DisposalFacility) -> Bool {
        return lhs.id == rhs.id
    }

}
