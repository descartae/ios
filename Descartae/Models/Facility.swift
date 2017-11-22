//
//  Center.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 20/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo

extension Facility: Equatable {

    public static func == (lhs: Facility, rhs: Facility) -> Bool {
        return lhs.id == rhs.id
    }

}
