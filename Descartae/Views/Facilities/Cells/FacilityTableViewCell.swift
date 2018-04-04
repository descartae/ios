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

    var facility: DisposalFacility! {
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
        distanceTo.text = facility.distanceFromUser

        let typesOfWaste = facility.typesOfWaste.compactMap({$0})
        let endOfPreviewIndex = typesOfWaste.count >= 3 ? 2 : typesOfWaste.count - 1
        let typesOfWasteToPreview = typesOfWaste[0...endOfPreviewIndex]

        for typeOfWaste in typesOfWasteToPreview {
            let iconFrame = CGRect(x: 0, y: 0, width: typeOfWasteIconSize.constant, height: typeOfWasteIconSize.constant)
            let typeOfWasteIconView = UIImageView(frame: iconFrame)

            if let iconURL = URL(string: typeOfWaste.icons.iosSmallUrl) {
                typeOfWasteIconView.sd_setImage(with: iconURL, placeholderImage: UIImage(named: "icWasteEmpty"), completed: nil)
            }

            typesOfWasteStackView.addArrangedSubview(typeOfWasteIconView)
            addConstraintsTo(typeOfWasteIconView: typeOfWasteIconView)
        }

        let exceedsPreviewLimit = typesOfWaste.count > previewLimit

        if exceedsPreviewLimit {
            let iconFrame = CGRect(x: 0, y: 0, width: typeOfWasteIconSize.constant, height: typeOfWasteIconSize.constant)
            let moreTypesOfWasteIconView = UIImageView(frame: iconFrame)
            moreTypesOfWasteIconView.image = UIImage(named: "icWasteMore")
            typesOfWasteStackView.addArrangedSubview(moreTypesOfWasteIconView)
            addConstraintsTo(typeOfWasteIconView: moreTypesOfWasteIconView)
        }

        let iconsWidthMultiplier = exceedsPreviewLimit ? CGFloat(typesOfWasteToPreview.count + 1) : CGFloat(typesOfWasteToPreview.count)
        let spacingMultiplier = exceedsPreviewLimit ? CGFloat(endOfPreviewIndex + 1) : CGFloat(endOfPreviewIndex)
        let iconsWidth = iconsWidthMultiplier * typeOfWasteIconSize.constant
        let spacing = spacingMultiplier * typesOfWasteStackView.spacing
        typesOfWasteStackViewWidth.constant = iconsWidth + spacing
        typesOfWasteStackView.layoutIfNeeded()
    }

    func addConstraintsTo(typeOfWasteIconView: UIImageView) {
        typeOfWasteIconView.translatesAutoresizingMaskIntoConstraints = false
        typeOfWasteIconView.heightAnchor.constraint(equalToConstant: typeOfWasteIconSize.constant).isActive = true
        typeOfWasteIconView.widthAnchor.constraint(equalToConstant: typeOfWasteIconSize.constant).isActive = true
    }

}
