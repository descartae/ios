//
//  EmptyStateViewController.swift
//  Descartae
//
//  Created by Filipe Alvarenga on 29/01/18.
//  Copyright © 2018 Filipe Alvarenga. All rights reserved.
//

import UIKit

class EmptyStateViewController: UIViewController {

    // MARK: Properties

    static let identifier = String(describing: EmptyStateViewController.self)

    @IBOutlet weak var emptyStateTitle: UILabel! {
        didSet {
            emptyStateTitle.text = localized("empty_state_title")
        }
    }

    @IBOutlet weak var emptyStateSubtitle: UILabel! {
        didSet {
            emptyStateSubtitle.text = localized("empty_state_subtitle")
        }
    }

    @IBOutlet weak var clearFiltersButton: UIButton! {
        didSet {
            clearFiltersButton.setTitle(localized("clear_filters_button_title"), for: .normal)
        }
    }


    var clearFilters: (() -> Void)?

    // MARK: Actions

    @IBAction func clearFilters(_ sender: Any) {
        clearFilters?()
    }
}
