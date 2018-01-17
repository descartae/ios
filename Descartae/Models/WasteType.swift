//
//  TypeOfWaste.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 30/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation

extension WasteType: Equatable {

    public static func == (lhs: WasteType, rhs: WasteType) -> Bool {
        return lhs.id == rhs.id
    }

}
