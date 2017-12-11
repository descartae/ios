//
//  ContactTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 09/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

protocol ContactTableViewCellDelegate: class {
    func didTouchContactButton(atIndexPath indexPath: IndexPath)
}

class ContactTableViewCell: FacilityDetailsBaseTableViewCell {

    // MARK: Properties

    static let identifier = String(describing: ContactTableViewCell.self)
    static let rowHeight: CGFloat = 84

    @IBOutlet weak var contactType: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var contactActionButton: UIButton!

    weak var delegate: ContactTableViewCellDelegate?
    var indexPath: IndexPath!

    // MARK: Actions

    @IBAction func didTouchContactButton(_ sender: UIButton) {
        delegate?.didTouchContactButton(atIndexPath: indexPath)
    }

}
