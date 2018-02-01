//
//  TypeOfWasteFilterTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 16/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class TypeOfWasteFilterTableViewCell: UITableViewCell {

    // MARK: Properties

    static let identifier = String(describing: TypeOfWasteFilterTableViewCell.self)
    static let rowHeight: CGFloat = 44

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!

    var wasteType: WasteType! {
        didSet {
            bindWasteTypeData()
        }
    }

    // MARK: Data bind

    func bindWasteTypeData() {
        name.text = wasteType.name
        if let iconURL = URL(string: wasteType.icons.iosSmallUrl) {
            icon.sd_setImage(with: iconURL, placeholderImage: UIImage(named: "icWasteEmpty"), completed: nil)
        }
    }
}
