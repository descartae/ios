//
//  TypeOfWasteCollectionViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 11/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

class TypeOfWasteCollectionViewCell: UICollectionViewCell {

    // MARK: Properties

    static let itemSize: CGSize = CGSize(width: 44, height: 44)
    static let identifier: String = "typeOfWasteCell"

    @IBOutlet weak var icon: UIImageView!

    var typeOfWaste: DisposalFacility.TypesOfWaste! {
        didSet {
            bindTypeOfWasteData()
        }
    }

    // MARK: Data binding

    func bindTypeOfWasteData() {
        if let iconURL = URL(string: typeOfWaste.icons.iosLargeUrl) {
//            icon.sd_setImage(with: iconURL, completed: nil)
        }
    }
}
