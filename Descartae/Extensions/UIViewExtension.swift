//
//  UIViewExtension.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 22/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    static var nib: UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }

    static func instantiateFromNib() -> Self? {
        func instanceFromNib<T: UIView>() -> T? {
            return nib.instantiate() as? T
        }

        return instanceFromNib()
    }

}
