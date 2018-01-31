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

    @IBOutlet weak var icon: UIButton!

    var presentTypeOfWasteModal: (() -> Void)?
    var typeOfWaste: DisposalFacility.TypesOfWaste! {
        didSet {
            bindTypeOfWasteData()
        }
    }

    // MARK: Data binding

    func bindTypeOfWasteData() {
        if let iconURL = URL(string: typeOfWaste.icons.iosMediumUrl) {
            icon.sd_setImage(with: iconURL, for: .normal, placeholderImage: UIImage(named: "icWasteEmptyMedium"), completed: nil)
        }
    }

    // MARK: Actions

    @IBAction func presentTypeOfWasteModal(_ sender: Any) {
        presentTypeOfWasteModal?()
    }

}
