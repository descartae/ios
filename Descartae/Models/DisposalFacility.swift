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

    var openHoursForToday: String {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let weekday = calendar.component(.weekday, from: Date())
        guard let todayOpenHour = openHours.filter({ $0?.dayOfWeek.toInt == weekday }).first as? DisposalFacility.OpenHour else {
            return "Horários de hoje indisponíveis"
        }

        return "Hoje - \(todayOpenHour.openHours)"
    }

    public static func == (lhs: DisposalFacility, rhs: DisposalFacility) -> Bool {
        return lhs.id == rhs.id
    }

}
