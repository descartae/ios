//
//  TypeOfWaste.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 30/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation

extension DisposalFacility.TypesOfWaste: Equatable {

    public static func == (lhs: DisposalFacility.TypesOfWaste, rhs: DisposalFacility.TypesOfWaste) -> Bool {
        return lhs.id == rhs.id
    }

}
