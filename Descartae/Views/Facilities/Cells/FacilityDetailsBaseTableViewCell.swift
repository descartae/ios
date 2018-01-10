//
//  FacilityDetailsBaseTableViewCell.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 08/12/17.
//  Copyright © 2017 Filipe Alvarenga. All rights reserved.
//

import UIKit

class FacilityDetailsBaseTableViewCell: UITableViewCell {

    // MARK: Properties

    private let heightConstant: CGFloat = 1
    private let leadingConstant: CGFloat = 16
    private var widthConstant: CGFloat {
        return UIScreen.main.bounds.width - leadingConstant * 2
    }
    private var bottomConstant: CGFloat {
        return heightConstant / 2 * -1
    }

    private lazy var separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false

        return separator
    }()

    private let separatorViewAnimationDuration = 0.25
    var shouldShowSeparator = false {
        didSet {
            if shouldShowSeparator {
                showSeparator()
            } else {
                hideSeparator()
            }
        }
    }

    // MARK: Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupSeparator()
    }

    // MARK: Separator helpers

    private func setupSeparator() {
        addSubview(separatorView)

        separatorView.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: bottomConstant
        ).isActive = true

        separatorView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: leadingConstant
        ).isActive = true

        separatorView.heightAnchor.constraint(
            equalToConstant: heightConstant
        ).isActive = true

        separatorView.widthAnchor.constraint(
            equalToConstant: widthConstant
        ).isActive = true
    }

    private func showSeparator() {
        UIView.animate(withDuration: separatorViewAnimationDuration) {
            self.separatorView.alpha = 1
        }
    }

    private func hideSeparator() {
        UIView.animate(withDuration: separatorViewAnimationDuration) {
            self.separatorView.alpha = 0
        }
    }

}
