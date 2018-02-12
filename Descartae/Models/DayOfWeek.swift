//
//  DayOfWeek.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 09/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation

extension DayOfWeek {

    var toInt: Int {
        switch self {
        case .sunday:
            return 1
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        default:
            return 10
        }
    }

    var toString: String {
        switch self {
        case .sunday:
            return localized("sunday")
        case .monday:
            return localized("monday")
        case .tuesday:
            return localized("tuesday")
        case .wednesday:
            return localized("wednesday")
        case .thursday:
            return localized("thursday")
        case .friday:
            return localized("friday")
        case .saturday:
            return localized("saturday")
        default:
            return ""
        }
    }

}
