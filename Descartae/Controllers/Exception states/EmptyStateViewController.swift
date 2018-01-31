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
    var clearFilters: (() -> Void)?

    // MARK: Actions

    @IBAction func clearFilters(_ sender: Any) {
        clearFilters?()
    }
}
