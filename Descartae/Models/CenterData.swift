//
//  Center.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 20/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import Apollo

extension CenterData: Equatable {

    public static func == (lhs: CenterData, rhs: CenterData) -> Bool {
        return lhs.id == rhs.id
    }

}
