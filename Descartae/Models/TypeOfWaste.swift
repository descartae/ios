//
//  TypeOfWaste.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 30/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation

extension Facility.TypesOfWaste: Equatable {

    public static func == (lhs: Facility.TypesOfWaste, rhs: Facility.TypesOfWaste) -> Bool {
        return lhs.id == rhs.id
    }

}

