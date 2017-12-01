//
//  FacilityTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 22/11/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit
import SDWebImage

class FacilityTableViewCell: UITableViewCell {

    // MARK: Properties

    static let identifier = String(describing: FacilityTableViewCell.self)
    static let estimatedRowHeight: CGFloat = 114

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distanceTo: UILabel!
    @IBOutlet weak var typesOfWasteStackView: UIStackView!
    @IBOutlet weak var typeOfWasteIconSize: NSLayoutConstraint!
    @IBOutlet weak var typesOfWasteStackViewWidth: NSLayoutConstraint!

    let previewLimit = 3

    var facility: Facility! {
        didSet {
            setupFacility()
        }
    }

    // MARK: Life cycle

    override func prepareForReuse() {
        super.prepareForReuse()

        name.text = ""
        address.text = ""
        distanceTo.text = ""

        for subview in typesOfWasteStackView.arrangedSubviews {
            typesOfWasteStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

    // MARK: Setup

    func setupFacility() {
        name.text = facility.name
        address.text = facility.location.address
        distanceTo.text = String(format: "%.2fKM", LocationManager.shared.distanceInKm(fromLocation: facility.location.location))

        let typesOfWaste = facility.typesOfWaste!.flatMap({$0})
        let endOfPreviewIndex = typesOfWaste.count >= 3 ? 2 : typesOfWaste.count - 1
        let typesOfWasteToPreview = typesOfWaste[0...endOfPreviewIndex]

        for typeOfWaste in typesOfWasteToPreview {
            let iconFrame = CGRect(x: 0, y: 0, width: typeOfWasteIconSize.constant, height: typeOfWasteIconSize.constant)
            let typeOfWasteIconView = UIImageView(frame: iconFrame)
            // TODO: Set placeholder
            if let iconURL = URL(string: typeOfWaste.icon) {
                typeOfWasteIconView.sd_setImage(with: iconURL, completed: nil)
            }

            typesOfWasteStackView.addArrangedSubview(typeOfWasteIconView)
            addConstraintsTo(typeOfWasteIconView: typeOfWasteIconView)
        }

        if typesOfWaste.count > previewLimit {
            let iconFrame = CGRect(x: 0, y: 0, width: typeOfWasteIconSize.constant, height: typeOfWasteIconSize.constant)
            let moreTypesOfWasteIconView = UIImageView(frame: iconFrame)
            moreTypesOfWasteIconView.backgroundColor = .red
            // TODO: Set more asset
            typesOfWasteStackView.addArrangedSubview(moreTypesOfWasteIconView)
            addConstraintsTo(typeOfWasteIconView: moreTypesOfWasteIconView)
        }

        let iconsWidth = CGFloat(typesOfWasteToPreview.count) * typeOfWasteIconSize.constant
        let spacing = CGFloat(endOfPreviewIndex) * typesOfWasteStackView.spacing
        typesOfWasteStackViewWidth.constant = iconsWidth + spacing
        typesOfWasteStackView.layoutIfNeeded()
    }

    func addConstraintsTo(typeOfWasteIconView: UIImageView) {
        typeOfWasteIconView.translatesAutoresizingMaskIntoConstraints = false
        typeOfWasteIconView.heightAnchor.constraint(equalToConstant: typeOfWasteIconSize.constant).isActive = true
        typeOfWasteIconView.widthAnchor.constraint(equalToConstant: typeOfWasteIconSize.constant).isActive = true
    }

}
