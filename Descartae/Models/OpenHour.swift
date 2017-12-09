//
//  OpenHour.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 09/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation

extension DisposalFacility.OpenHour {

    var openHours:  String {
        return "Aberto das \(startTime)h às \(endTime)h"
    }

}
