//
//  WasteTypeTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 17/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class WasteTypeTableViewCell: UITableViewCell {

    // MARK: Properties

    static let identifier = String(describing: WasteTypeTableViewCell.self)
    static let rowHeight: CGFloat = 83

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var typeDescription: UILabel!

    var wasteType: WasteType! {
        didSet {
            bindWasteTypeData()
        }
    }

    // MARK: Data bind

    func bindWasteTypeData() {
        name.textColor = UIColor(hexString: wasteType.color)
        name.text = wasteType.name
        typeDescription.text = wasteType.description
        if let iconURL = URL(string: wasteType.icons.iosSmallUrl) {
            icon.sd_setImage(with: iconURL)
        }
    }

}
