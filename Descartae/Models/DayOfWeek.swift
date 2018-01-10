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
            return "Domingo"
        case .monday:
            return "Segunda-feira"
        case .tuesday:
            return "Terça-feira"
        case .wednesday:
            return "Quarta-feira"
        case .thursday:
            return "Quinta-feira"
        case .friday:
            return "Sexta-feira"
        case .saturday:
            return "Sábado"
        default:
            return ""
        }
    }

}
