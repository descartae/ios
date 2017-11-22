//
//  UINibExtension.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 22/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

extension UINib {

    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }

}
