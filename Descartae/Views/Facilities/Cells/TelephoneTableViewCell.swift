//
//  TelephoneTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 09/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

protocol TelephoneTableViewCellDelegate: class {
    func didTouchCallButton(_ button: UIButton)
}

class TelephoneTableViewCell: FacilityDetailsBaseTableViewCell {

    // MARK: Properties

    static let identifier = String(describing: TelephoneTableViewCell.self)
    static let estimatedRowHeight: CGFloat = 84

    @IBOutlet weak var telephone: UILabel!

    weak var delegate: TelephoneTableViewCellDelegate?

    // MARK: Actions

    @IBAction func didTouchCallButton(_ sender: UIButton) {
        delegate?.didTouchCallButton(sender)
    }

}
